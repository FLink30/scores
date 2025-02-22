import Foundation

// MARK: - Login Service Protocol
protocol LoginService: AnyObject {
    /// Sign in the user with the provide credentials
    /// - Parameters:
    ///   - email: user's email address
    ///   - password: user's password
    /// - Throws: ``SignInServiceError``
    func signIn(email: String, password: String) async throws -> UUID
}

// MARK: - Remote Sign In Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteLoginHandler: AnyObject {
    /// Sign in the user with the provide credentials
    /// - Parameters:
    ///   - email: user's email address
    ///   - password: user's password
    /// - Throws: ``CommonCloudRequest.CloudServiceError``
    func signIn(email: String, password: String) async throws -> CloudIdentityRaw
}

// MARK: - Sign In Service Error
enum LoginServiceError: Error {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToGetID
    
    var loginRequestError: LoginRequestError {
        switch self {
        case .executionError(let string):
            return .unexpected(string)
        case .requestError(let string, let cloudServiceError):
            if case .httpResponseError(let hTTPResponseError, let response) = cloudServiceError {
                switch hTTPResponseError {
                case .unauthorized:
                    return .userNotFound
                case .notFound:
                    return .wrongPassword
                case .badRequest:
                    return .invalidData
                default:
                    return .unexpected(response?.message)
                }
            } else {
                return .unexpected(string)
            }
        case .unexpectedError(let string, _):
            return .unexpected(string)
        case .failedToGetID:
            return .unexpected(nil)
        }
    }
}

enum LoginRequestError: Error {
    case invalidData
    case wrongPassword
    case userNotFound
    case unexpected(String?)
}

// MARK: - Sign In Provider
final class LoginProvider {
    
    // MARK: - Private Properties
    private var remoteLoginHandler: RemoteLoginHandler
    
    // MARK: - Init
    init(remoteLoginHandler: RemoteLoginHandler) {
        self.remoteLoginHandler = remoteLoginHandler
    }
}

// MARK: - Sign In Service Implementation
extension LoginProvider: LoginService {
    func signIn(email: String, password: String) async throws -> UUID {
        do {
            let cloudIdentityRaw = try await remoteLoginHandler.signIn(email: email, password: password)
            let id = try TokenDecoder.makeCloudIdentity(from: cloudIdentityRaw).sessionToken.identifier
            guard let uuid = UUID(uuidString: id) else {
                throw LoginServiceError.failedToGetID
            }
            return uuid
        } catch let error as CloudServiceError {
            throw LoginServiceError.requestError("while signing in", error)
        } catch {
            throw LoginServiceError.unexpectedError("while signing in", error)
        }
    }
}
