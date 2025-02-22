import Foundation

// MARK: - Players Service Protocol
protocol PlayersService: AnyObject {
    func createPlayer(player: Players) async throws -> Players
    func getPlayers() async throws -> [Players]
    func getPlayer(playerID: UUID) async throws -> Players
    func deletePlayer(playerID: UUID) async throws
    func updatePlayer(_ player: Players) async throws
}

// MARK: - Remote Players Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemotePlayersHandler: AnyObject {
    func createPlayer(requestBody: CreatePlayersRequestBody) async throws -> CreatePlayersResponseBody
    func getPlayers(parameter: [GamesParameter]) async throws -> [PlayersBackend]
    func getPlayer(playerID: String) async throws -> PlayersBackend
    func deletePlayer(playerID: String) async throws -> String
    func updatePlayer(requestBody: PlayersBackend) async throws
}

// MARK: - Players Service Error
enum PlayersServiceError: CustomError {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToCreatePlayer
    case playerNotFound
    
    var asString: String {
        switch self {
        case .failedToCreatePlayer:
            return "Beim Erstellen eine Spielers ist ein Fehler aufgetreten. Versuche es später erneut."
        case .playerNotFound:
            return "Ein Spieler wurde nicht gefunden. VErsuche es später erneut"
        default:
            return "Ein unerwarteter Fehler ist aufgetreten: \(self)."
        }
    }
}

// MARK: - Players Provider
final class PlayersProvider {
    
    // MARK: - Private Properties
    private var remotePlayersHandler: RemotePlayersHandler
    
    // MARK: - Init
    init(remotePlayersHandler: RemotePlayersHandler) {
        self.remotePlayersHandler = remotePlayersHandler
    }
}

// MARK: - Players Service Implementation
extension PlayersProvider: PlayersService {
    
    func createPlayer(player: Players) async throws -> Players {
        do {
            let response = try await remotePlayersHandler.createPlayer(requestBody: player.asCreatePlayersRequestBody)
            guard let player = Players(body: response) else {
                throw PlayersServiceError.failedToCreatePlayer
            }
            return player
        } catch let error as CloudServiceError {
            throw PlayersServiceError.requestError("while creating Player", error)
        } catch {
            throw PlayersServiceError.unexpectedError("while creating Player", error)
        }
    }
    
    func getPlayers() async throws -> [Players] {
        do {
            let response = try await remotePlayersHandler.getPlayers(parameter: [GamesParameter.page(1),
                                                                                 GamesParameter.pageSize(100)])
            return response.compactMap({ Players(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .badRequest = hTTPResponseError {
                    return []
                }
            }
            throw PlayersServiceError.requestError("while retrieving Players", error)
        } catch {
            throw PlayersServiceError.unexpectedError("while retrieving Players", error)
        }
    }
    
    func getPlayer(playerID: UUID) async throws -> Players {
        do {
            let response = try await remotePlayersHandler.getPlayer(playerID: playerID.uuidString)
            guard let player = Players(body: response) else {
                throw PlayersServiceError.failedToCreatePlayer
            }
            return player
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .badRequest = hTTPResponseError {
                    throw PlayersServiceError.playerNotFound
                }
            }
            throw PlayersServiceError.requestError("while retrieving Player", error)
        } catch {
            throw PlayersServiceError.unexpectedError("while retrieving Player", error)
        }
    }
    
    func deletePlayer(playerID: UUID) async throws {
        do {
            let _ = try await remotePlayersHandler.deletePlayer(playerID: playerID.uuidString)
        } catch let error as CloudServiceError {
            throw PlayersServiceError.requestError("while deleting Player", error)
        } catch {
            throw PlayersServiceError.unexpectedError("while deleting Player", error)
        }
    }
    
    func updatePlayer(_ player: Players) async throws {
        do {
            try await remotePlayersHandler.updatePlayer(requestBody: player.asRequestBody)
        } catch let error as CloudServiceError {
            throw PlayersServiceError.requestError("while updating Player", error)
        } catch {
            throw PlayersServiceError.unexpectedError("while updating Player", error)
        }
    }
}
