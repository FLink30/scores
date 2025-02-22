import Foundation

// MARK: - Teams Service Protocol
protocol TeamsService: AnyObject {
    func findTeams(association: Association, league: League, series: Season) async throws -> [Teams]
    func getTeamByID(id: UUID) async throws -> Teams
    func deleteTeam(id: UUID) async throws
    func getTeamByID(adminID: UUID) async throws -> Teams
    func registerTeam(_ team: Teams) async throws -> Teams
    func updateTeam(_ team: Teams) async throws
}

// MARK: - Remote Teams Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteTeamsHandler: AnyObject {
    func findTeams(parameter: [TeamsParameter]) async throws -> [TeamsBackend]
    func getTeamByID(id: String) async throws -> TeamsBackend
    func deleteTeam(id: String) async throws -> String
    func getTeamByID(adminID: String) async throws -> TeamsBackend
    func registerTeam(requestBody: RegisterTeamsRequestBody) async throws -> CreateTeamsResponseBody
    func updateTeam(requestBody: TeamsBackend) async throws -> TeamsBackend
}

// MARK: - Teams Service Error
enum TeamsServiceError: Error {
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    case failedToCreateTeam
    
    var teamsRequestError: TeamsRequestError {
        switch self {
        case .executionError(let string):
            return .unexpected(string)
        case .requestError(let string, let cloudServiceError):
            if case .httpResponseError(let hTTPResponseError, let response) = cloudServiceError {
                switch hTTPResponseError {
                case .notFound:
                    return .teamNotFound
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

enum TeamsRequestError: CustomError {
    case teamNotFound
    case invalidData
    case unexpected(String?)
    
    var asString: String {
        switch self {
        case .teamNotFound:
            return "Dein Team wurde nicht gefunden. Versuche es später erneut."
        case .unexpected(let string):
            return "Ein unerwarteter Fehler ist aufgetreten: \(String(describing: string))."
        case .invalidData:
            return "Die eingegebenen Daten sind nicht valide."
        }
    }
}

// MARK: - Teams Provider
final class TeamsProvider {
    
    // MARK: - Private Properties
    private var remoteTeamsHandler: RemoteTeamsHandler
    
    // MARK: - Init
    init(remoteTeamsHandler: RemoteTeamsHandler) {
        self.remoteTeamsHandler = remoteTeamsHandler
    }
}

// MARK: - Teams Service Implementation
extension TeamsProvider: TeamsService {
    
    func findTeams(association: Association, league: League, series: Season) async throws -> [Teams] {
        do {
            let response = try await remoteTeamsHandler.findTeams(parameter: [.association(association()), .league(league()), .series(series())])
            if response.isEmpty {
                return []
            } else {
                return response.map({ Teams(body: $0) })
            }
            
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while finding teams", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while finding teams", error)
        }
    }
    
    func getTeamByID(id: UUID) async throws -> Teams {
        do {
            let response = try await remoteTeamsHandler.getTeamByID(id: id.uuidString.lowercased())
            return Teams(body: response)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while finding team", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while finding team", error)
        }
    }
    
    func deleteTeam(id: UUID) async throws {
        do {
            _ = try await remoteTeamsHandler.deleteTeam(id: id.uuidString)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while deleting team", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while deleting team", error)
        }
    }
    
    func getTeamByID(adminID: UUID) async throws -> Teams {
        do {
            let response = try await remoteTeamsHandler.getTeamByID(adminID: adminID.uuidString)
            return Teams(body: response)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while finding team", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while finding team", error)
        }
    }
    
    func registerTeam(_ team: Teams) async throws -> Teams {
        do {
            let response = try await remoteTeamsHandler.registerTeam(requestBody: team.asRegisterRequestBody)
            return Teams(body: response)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while registering team", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while registering team", error)
        }
    }
    
    func updateTeam(_ team: Teams) async throws {
        do {
            let _ = try await remoteTeamsHandler.updateTeam(requestBody: team.asRequestBody)
        } catch let error as CloudServiceError {
            throw TeamsServiceError.requestError("while updating team", error)
        } catch {
            throw TeamsServiceError.unexpectedError("while updating team", error)
        }
    }
}
