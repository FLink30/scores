import Foundation

// MARK: - Profile Service Protocol
protocol ProfileService: AnyObject {
    func retrieveProfile() async throws -> TokenDetails
    func getProfile() async throws -> Profile
}

// MARK: - Remote Profile Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteProfileHandler: AnyObject {
    func retrieveProfile() async throws -> TokenDetails
    func getProfile() async throws -> ProfileResponseBody
}

// MARK: - Profile Service Error
enum ProfileServiceError: CustomError {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToCreateProfile
    
    var asString: String {
        switch self {
        case .failedToCreateProfile:
            return "Beim Erstellen eines Profils ist ein Fehler aufgetreten. Versuche es später erneut."
        default:
            return "Ein unerwarteter Fehler ist aufgetreten: \(self)."
        }
    }
}

// MARK: - Profile Provider
final class ProfileProvider {
    
    // MARK: - Private Properties
    private var remoteProfileHandler: RemoteProfileHandler
    
    // MARK: - Init
    init(remoteProfileHandler: RemoteProfileHandler) {
        self.remoteProfileHandler = remoteProfileHandler
    }
}

// MARK: - Profile Service Implementation
extension ProfileProvider: ProfileService {

    func retrieveProfile() async throws -> TokenDetails {
        do {
            return try await remoteProfileHandler.retrieveProfile()
        } catch let error as CloudServiceError {
            throw ProfileServiceError.requestError("while retrieving Profile", error)
        } catch {
            throw ProfileServiceError.unexpectedError("while retrieving Profile", error)
        }
    }
    
    func getProfile() async throws -> Profile {
        do {
            let response = try await remoteProfileHandler.getProfile()
            guard let profile = Profile(body: response) else {
                throw ProfileServiceError.failedToCreateProfile
            }
            return profile
        } catch let error as CloudServiceError {
            throw ProfileServiceError.requestError("while retrieving Profile", error)
        } catch {
            throw ProfileServiceError.unexpectedError("while retrieving Profile", error)
        }
    }
}
