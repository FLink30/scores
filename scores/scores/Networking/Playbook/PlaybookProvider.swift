import Foundation

// MARK: - Playbook Service Protocol
protocol PlaybookService: AnyObject {
    func createPlaybook(play: Play) async throws -> Play
    func getPlaybooks(teamID: UUID) async throws -> [Play]
    func deletePlaybook(playID: UUID) async throws
}

// MARK: - Remote Playbook Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemotePlaybookHandler: AnyObject {
    func createPlaybook(body: CreatePlaybookRequestBody) async throws -> PlaybookBackend
    func getPlaybooks(id: String) async throws -> [PlaybookBackend]
    func deletePlaybook(id: String) async throws -> String
}

enum PlaybookServiceError: CustomError {
    case playbookNotFound
    case failedToCreatePlaybook
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    
    var asString: String {
        switch self {
        case .failedToCreatePlaybook:
            return "Beim Erstellen eines Spielzuges ist ein Fehler aufgetreten. Versuche es später erneut."
        case .playbookNotFound:
            return "Ein Spielzug wurde nicht gefunden. VErsuche es später erneut"
        default:
            return "Ein unerwarteter Fehler ist aufgetreten: \(self)."
        }
    }
}

// MARK: - Playbook Provider
final class PlaybookProvider {
    
    // MARK: - Private Properties
    private var remotePlaybookHandler: RemotePlaybookHandler
    
    // MARK: - Init
    init(remotePlaybookHandler: RemotePlaybookHandler) {
        self.remotePlaybookHandler = remotePlaybookHandler
    }
}

// MARK: - Playbook Service Implementation
extension PlaybookProvider: PlaybookService {
    func createPlaybook(play: Play) async throws -> Play {
        do {
            let response = try await remotePlaybookHandler.createPlaybook(body: play.asCreatePlaybookRequestBody)
            guard let play = Play(body: response) else {
                throw PlaybookServiceError.failedToCreatePlaybook
            }
            return play
        } catch let error as CloudServiceError {
            throw PlaybookServiceError.requestError("while creating Playbook", error)
        } catch {
            throw PlaybookServiceError.unexpectedError("while creating Playbook", error)
        }
    }
    
    func getPlaybooks(teamID: UUID) async throws -> [Play]{
        do {
            let response = try await remotePlaybookHandler.getPlaybooks(id: teamID.uuidString)
            return response.compactMap({ Play(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .badRequest = hTTPResponseError {
                    throw PlaybookServiceError.playbookNotFound
                }
            }
            throw PlaybookServiceError.requestError("while retrieving Playbook", error)
        } catch {
            throw PlaybookServiceError.unexpectedError("while retrieving Playbook", error)
        }
    }
    
    func deletePlaybook(playID: UUID) async throws {
        do {
            let _ = try await remotePlaybookHandler.deletePlaybook(id: playID.uuidString)
        } catch let error as CloudServiceError {
            throw PlaybookServiceError.requestError("while deleting Playbook", error)
        } catch {
            throw PlaybookServiceError.unexpectedError("while deleting Playbook", error)
        }
    }
}
