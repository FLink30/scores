import Foundation

// MARK: - Registration Service Protocol
protocol RegistrationService: AnyObject {
    func register(email: String, password: String, firstName: String, lastName: String) async throws -> UUID
}

// MARK: - Remote Sign In Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteRegistrationHandler: AnyObject {
    func register(body: RegistrationRequestBody) async throws -> CloudIdentityRaw
}

// MARK: - Sign In Service Error
enum RegistrationServiceError: Error {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToGetID
    
    var registrationRequestError: RegistrationRequestError {
        switch self {
        case .executionError(let string):
            return .unexpected(string)
        case .requestError(let string, let cloudServiceError):
            if case .httpResponseError(let hTTPResponseError, let response) = cloudServiceError {
                switch hTTPResponseError {
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
        default:
            return .unexpected(nil)
        }
    }
}

enum RegistrationRequestError: Error {
    case invalidData
    case unexpected(String?)
}

// MARK: - Registration Provider
final class RegistrationProvider {
    
    // MARK: - Private Properties
    private var remoteRegistrationHandler: RemoteRegistrationHandler
    
    // MARK: - Init
    init(remoteRegistrationHandler: RemoteRegistrationHandler) {
        self.remoteRegistrationHandler = remoteRegistrationHandler
    }
}

// MARK: - Registration Service Implementation
extension RegistrationProvider: RegistrationService {

    func register(email: String, password: String, firstName: String, lastName: String) async throws -> UUID {
        do {
            let cloudIdentityRaw = try await remoteRegistrationHandler.register(
                body: RegistrationRequestBody(
                    mail: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                )
            )
            let id = try TokenDecoder.makeCloudIdentity(from: cloudIdentityRaw).sessionToken.identifier
            guard let uuid = UUID(uuidString: id) else {
                throw LoginServiceError.failedToGetID
            }
            return uuid
            
        } catch let error as CloudServiceError {
            throw RegistrationServiceError.requestError("while registering", error)
        } catch {
            throw RegistrationServiceError.unexpectedError("while registering", error)
        }
    }
}
