import Foundation
import OSLog

// MARK: - CloudRequestExecuterAuthenticationErrorHandlingMode
enum CloudRequestExecuterAuthenticationErrorHandlingMode {
    case refreshToken
    case forwardError
}

// MARK: - CommonCloudRequestExecuter
public class CommonCloudRequestExecuter {
    
    // MARK: - Private Properties
    private let session: Session
    private var authenticationService: AuthenticationService!
    
    // MARK: - Init
    /// - Parameters:
    ///   - environment: specifies which environment to use (development, production) decoded from JSON
    public init(session: Session) {
        self.session = session
        self.authenticationService = AuthenticationHandler(cloudIdentityPersistencService: AuthenticationManager())
    }
}

// MARK: - Accessible Computed Properties
extension CommonCloudRequestExecuter {
    public var cloudIdentityManagementService: CloudIdentityManagementService {
        authenticationService
    }
}

// MARK: - Main Task
extension CommonCloudRequestExecuter: CloudRequestExecuter {
    /// Generic request
    /// - Parameters:
    ///   - cloudRequest: the ``CloudRequest`` to execute
    ///   - requestBody: the http body for the request (optional)
    /// - Returns: a single generic decoded object or error
    public func execute<T: Codable>(_ cloudRequest: CloudRequest, requestBody: Codable? = nil, queryItems: [URLQueryItem]? = nil) async throws -> T {
        var errorHandlingMode: CloudRequestExecuterAuthenticationErrorHandlingMode = .refreshToken
        if T.self == CloudIdentityRaw.self {
            errorHandlingMode = .forwardError
        }
        return try await invoke(cloudRequest, requestBody: requestBody, queryItems: queryItems, unauthorizedErrorHandlingMode: errorHandlingMode)
    }
    
    // MARK: URL Request Generator
    /// Generates the url request for the provided parameters
    /// - Parameters:
    ///   - cloudRequest: the ``CloudRequest`` to execute
    ///   - requestBody: the http body for the request (optional)
    /// - Returns: URLRequest for the URLSession or CloudServiceError
    public func generateURLRequest(for cloudRequest: CloudRequest, requestBody: Codable? = nil, queryItems: [URLQueryItem]? = nil) async -> Result<URLRequest, CloudServiceError> {
        var request = URLRequest(url: cloudRequest.url)
        request.httpMethod = cloudRequest.operation.httpMethod
        
        do {
            for header in cloudRequest.headers ?? [] {
                switch header {
                case.accept, .contentType:
                    request.applyHeader(header)
                case .acceptLanguage:
                    request.applyHeader(header)
                case .authorization:
                    let sessionToken = try await authenticationService.provideSessionToken()
                    request.applyHeader(HTTPHeader.authorization("Bearer \(sessionToken.raw)"))
                case .deviceIdentifier:
                    request.applyHeader(header)
                }
            }
            
            if let queryItems {
                var urlComponents = URLComponents(url: cloudRequest.url, resolvingAgainstBaseURL: true)!
                urlComponents.queryItems = queryItems
                request.url = urlComponents.url
            }
            
        } catch {
            self.logger.fault("Generate Request \(cloudRequest.shortDescription) :: failed to resolve header \(String(describing: error))")
            return .failure(.headerResolvingError)
        }
        
        guard let requestBody else {
            return .success(request)
        }
        
        if let requestBodyJSON = requestBody.asJSON {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBodyJSON, options: []) else {
                self.logger.fault("Generate Request \(cloudRequest.shortDescription) :: Invalid Request Body")
                return .failure(CloudServiceError.invalidRequestBody)
            }
            request.httpBody = httpBody
        } else if requestBody is [Codable] {
            if let requestBodyJSON = requestBody.asPlainJSONArray {
                guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBodyJSON, options: []) else {
                    self.logger.fault("Generate Request \(cloudRequest.shortDescription) :: Invalid Request Body")
                    return .failure(CloudServiceError.invalidRequestBody)
                }
                request.httpBody = httpBody
            } else {
                self.logger.fault(
                    "Generate Request \(cloudRequest.shortDescription) :: Invalid Request Body - could not be encoded to an array"
                )
            }
        }
        return .success(request)
    }
}

// MARK: - Framework Accessible Functions
extension CommonCloudRequestExecuter {
    func invoke<T: Codable>(_ cloudRequest: CloudRequest,
                            requestBody: Codable? = nil,
                            queryItems: [URLQueryItem]? = nil,
                            unauthorizedErrorHandlingMode: CloudRequestExecuterAuthenticationErrorHandlingMode = .forwardError) async throws -> T {
        let result = await generateURLRequest(for: cloudRequest, requestBody: requestBody, queryItems: queryItems)
        switch result {
        case .success(let request):
            self.logger.debug("\(CloudRequestLogDescription.executing(cloudRequest, request))")
            let (data, response) = try await session.data(for: request, delegate: nil)
            if let httpResponse = response as? HTTPURLResponse {
                let code = HTTPStatusCode.init(rawValue: httpResponse.statusCode)
                var response: Response?
                do {
                    response = try JSONDecoder().decode(Response.self, from: data)
                } catch {
                }
                switch code {
                case .ok, .created:
                    let result: T = try handleResponse(data: data, ofSuccessful: cloudRequest, with: code)
                    return result
                case .tooManyRequests:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .tooManyRequests)))")
                    throw CloudServiceError.httpResponseError(.tooManyRequests, response)
                case .noContent: // response from 'Delete' & 'Accepted TOS'
                    // the following force cast may not be permanent...
                    // need to figure out what we should return for the case for generic request
                    fatalError("handle noContent")
                case .unauthorized:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .unauthorized)))")
                    throw CloudServiceError.httpResponseError(.unauthorized, response)
                case .notFound:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .notFound)))")
                    throw CloudServiceError.httpResponseError(.notFound, response)
                case .badRequest:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .badRequest)))")
                    throw CloudServiceError.httpResponseError(.badRequest, response)
                case .forbidden:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .forbidden)))")
                    throw CloudServiceError.httpResponseError(.forbidden, response)
                case .gone:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .gone)))")
                    throw CloudServiceError.httpResponseError(.gone, response)
                case .requestTimeout:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, .requestTimeout)))")
                    throw CloudServiceError.httpResponseError(.timeout, response)
                case .inaccessibleDueToPendingEmailConfirmation:
                    throw CloudServiceError.emailConfirmationPending
                default:
                    self.logger.fault("\(CloudRequestLogDescription.receivedResponse(.failure(cloudRequest, nil)))")
                    throw CloudServiceError.httpResponseError(.unexpected("\(httpResponse.statusCode)"), response)
                }
            } else {
                self.logger.fault("\(cloudRequest.shortDescription) :: Response Error")
                throw CloudServiceError.responseError
            }
        case .failure(let cloudError):
            throw cloudError
        }
    }
}

// MARK: - Private Functions
extension CommonCloudRequestExecuter {
    private func handleResponse<T: Codable>(data: Data, ofSuccessful request: CloudRequest, with code: HTTPStatusCode?) throws -> T {
        self.logger.debug("\(CloudRequestLogDescription.receivedResponse(.success(request, data, code)))")
        if T.self == Bool.self {
            guard let boolValue = try? JSONDecoder().decode(Bool.self, from: data) else {
                throw CloudServiceError.jsonError(NSError(domain: "", code: 0, userInfo: nil))
            }
            return boolValue as! T
        }
        
        do {
            // Normale JSON-Decodierung für andere Typen
            let obj = try JSONDecoder().decode(T.self, from: data)
            
            // Wenn der Typ T das TokenCarrier-Protokoll implementiert, versuche, das Token zu verarbeiten
            if let tokenCarrier = obj as? TokenCarrier {
                try authenticationService.processTokens(from: tokenCarrier)
            }
            
            return obj
        } catch let jsonError {
            let dataString = String(decoding: data, as: UTF8.self)
            self.logger.fault(
                "\(request.shortDescription) :: Could not convert JSON for type \(T.self), received: \(dataString)"
            )
            throw CloudServiceError.jsonError(jsonError)
        }
    }
}


// MARK: - Logger
extension CommonCloudRequestExecuter {
    var logger: Logger {
        Logger.cloudService
    }
}

// MARK: - Test Specific Functions
extension CommonCloudRequestExecuter {
    func register(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
}
