import Foundation

// MARK: - Games Service Protocol
protocol GamesService: AnyObject {
    func createGame(game: Games) async throws -> Games
    func getGameByID(gamesID: UUID) async throws -> Games
    func getGamesByTeamID(teamID: UUID, numberOfGames: Int) async throws -> [Games]
    func getNextGame(teamID: UUID) async throws -> Games?
    func deleteGame(gamesID: UUID) async throws
    func updateGame(_ game: Games) async throws
}

// MARK: - Remote Games Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteGamesHandler: AnyObject {
    func createGame(requestBody: CreateGamesRequestBody) async throws -> CreateGamesResponseBody
    func getGameByID(gamesID: String) async throws -> GamesBackend
    func getGamesByTeamID(teamID: String, parameter: [GamesParameter]) async throws -> [GamesBackend]
    func deleteGame(gamesID: String) async throws -> String
    func updateGame(gameID: String, requestBody: UpdateGamesRequestBody) async throws -> UpdateGamesResponseBody
}

// MARK: - Games Service Error
enum GamesServiceError: Error {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToCreateGame
    
    var gamesRequestError: GamesRequestError {
        switch self {
        case .executionError(let string):
            return .unexpected(string)
        case .requestError(let string, let cloudServiceError):
            if case .httpResponseError(let hTTPResponseError, let response) = cloudServiceError {
                switch hTTPResponseError {
                case .notFound:
                    return .gameNotFound
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

enum GamesRequestError: CustomError {
    case gameNotFound
    case unexpected(String?)
    
    var asString: String {
        switch self {
        case .gameNotFound:
            return "Dein Spiel wurde nicht gefunden. Versuche es später erneut."
        case .unexpected(let string):
            return "Ein unerwarteter Fehler ist aufgetreten: \(String(describing: string))."
        }
    }
}

// MARK: - Games Provider
final class GamesProvider {
    
    // MARK: - Private Properties
    private var remoteGamesHandler: RemoteGamesHandler
    
    // MARK: - Init
    init(remoteGamesHandler: RemoteGamesHandler) {
        self.remoteGamesHandler = remoteGamesHandler
    }
}

// MARK: - Games Service Implementation
extension GamesProvider: GamesService {
    
    func createGame(game: Games) async throws -> Games {
        do {
            let response = try await remoteGamesHandler.createGame(requestBody: game.asCreateGamesRequestBody)
            guard let game = Games(body: response, homeTeam: game.homeTeam, opponentTeam: game.opponentTeam) else {
                throw GamesServiceError.failedToCreateGame
            }
            return game
        } catch let error as CloudServiceError {
            throw GamesServiceError.requestError("while creating Game", error)
        } catch {
            throw GamesServiceError.unexpectedError("while creating Game", error)
        }
    }
    
    func getGameByID(gamesID: UUID) async throws -> Games {
        do {
            let response = try await remoteGamesHandler.getGameByID(gamesID: gamesID.uuidString)
            guard let game = Games(body: response) else {
                throw GamesServiceError.failedToCreateGame
            }
            return game
        } catch let error as CloudServiceError {
            throw GamesServiceError.requestError("while retrieving Game", error)
        } catch {
            throw GamesServiceError.unexpectedError("while retrieving Game", error)
        }
    }
    
    func getGamesByTeamID(teamID: UUID, numberOfGames: Int) async throws -> [Games] {
        do {
            let response = try await remoteGamesHandler.getGamesByTeamID(teamID: teamID.uuidString, 
                                                                         parameter: [GamesParameter.page(1),
                                                                                     GamesParameter.pageSize(numberOfGames)])
            return response.compactMap({ Games(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .badRequest = hTTPResponseError {
                    return []
                }
            }
            throw GamesServiceError.requestError("while retrieving Games", error)
        } catch {
            throw GamesServiceError.unexpectedError("while retrieving Games", error)
        }
    }
    
    func getNextGame(teamID: UUID) async throws -> Games? {
        do {
            let response = try await remoteGamesHandler.getGamesByTeamID(teamID: teamID.uuidString.lowercased(),
                                                                         parameter: [GamesParameter.page(1),
                                                                                     GamesParameter.pageSize(1)])
            return response.compactMap({ Games(body: $0) }).first
        } catch let error as CloudServiceError {
            throw GamesServiceError.requestError("while retrieving Games", error)
        } catch {
            throw GamesServiceError.unexpectedError("while retrieving Games", error)
        }
    }
    
    func deleteGame(gamesID: UUID) async throws {
        do {
            _ = try await remoteGamesHandler.deleteGame(gamesID: gamesID.uuidString)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while deleting Game", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while deleting Game", error)
        }
    }
    
    func updateGame(_ game: Games) async throws {
        do {
            let _ = try await remoteGamesHandler.updateGame(gameID: game.id.uuidString, requestBody: game.asUpdateGamesRequestBody)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while updating Game", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while updating Game", error)
        }
    }
}
