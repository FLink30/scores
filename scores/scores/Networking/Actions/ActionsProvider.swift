import Foundation

// MARK: - Actions Service Protocol
protocol ActionsService: AnyObject {
    func createAction(type: ActionType) async throws -> UUID
    func getAllActionsSorted(gameID: UUID) async throws -> [ActionType]
    func deleteAction(actionID: UUID) async throws
}

// MARK: - Remote Actions Handler Protocol
/// this is the protocol the respective ``CloudRequestHandler`` implementation has to implement
protocol RemoteActionsHandler: AnyObject {
    func createAction(type: CreateActionBackend) async throws -> String
    func getGoalThrow(id: String) async throws -> [GoalThrowBackend]
    func getExchangePlayers(id: String) async throws -> [ExchangePlayersBackend]
    func getTRF(id: String) async throws -> [TRFBackend]
    func getPunishment(id: String) async throws -> [PunishmentBackend]
    func deleteAction(actionID: UUID) async throws
}

enum ActionsRequestError: CustomError {
    case failedToCreateUUID
    case failedToCreateRequestBody
    case executionError(String)
    case requestError(String, CloudServiceError)
    case unexpectedError(String, Error)
    
    var asString: String {
        switch self {
        case .failedToCreateUUID, .failedToCreateRequestBody:
            return "Beim Erstellen einer Aktion ist ein Fehler aufgetreten. Versuche es später erneut."
        default:
            return "Ein unerwarteter Fehler ist aufgetreten: \(self)."
        }
    }
}

// MARK: - Actions Provider
final class ActionsProvider {
    
    // MARK: - Private Properties
    private var remoteActionsHandler: RemoteActionsHandler
    
    // MARK: - Init
    init(remoteActionsHandler: RemoteActionsHandler) {
        self.remoteActionsHandler = remoteActionsHandler
    }
}

// MARK: - Actions Service Implementation
extension ActionsProvider: ActionsService {
    func createAction(type: ActionType) async throws -> UUID {
        do {
            var typeBackend: CreateActionBackend?
            switch type {
            case .goalThrow(let goalThrow):
                if let goalThrow {
                    typeBackend = .goalThrow(goalThrow.asGoalThrowRequestBody)
                }
            case .trf(let tRF):
                if let tRF {
                    typeBackend = .trf(tRF.asTRFRequestBody)
                }
            case .punishment(let punishment):
                if let punishment {
                    typeBackend = .punishment(punishment.asPunishmentRequestBody)
                }
            case .exchange(let exchangePlayers):
                if let exchangePlayers {
                    typeBackend = .exchange(exchangePlayers.asCreateExchangePlayersRequestBody)
                }
            }
            guard let typeBackend else {
                throw ActionsRequestError.failedToCreateRequestBody
            }
            let response = try await remoteActionsHandler.createAction(type: typeBackend)
            guard let id = UUID(uuidString: response) else {
                throw ActionsRequestError.failedToCreateUUID
            }
            return id
        } catch let error as CloudServiceError {
            throw ActionsRequestError.requestError("while creating Action \(type.asString)", error)
        } catch {
            throw ActionsRequestError.unexpectedError("while creating Action \(type.asString)", error)
        }
    }
    
    func getAllGoalThrowActions(gameID: UUID) async throws -> [GoalThrow] {
        do {
            let response = try await remoteActionsHandler.getGoalThrow(id: gameID.uuidString)
            return response.compactMap({ GoalThrow(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .notFound = hTTPResponseError {
                    return []
                }
            }
            throw ActionsRequestError.requestError("GoalThrowActions", error)
        } catch {
            throw ActionsRequestError.unexpectedError("GoalThrowActions", error)
        }
    }
    
    func getAllExchangeActions(gameID: UUID) async throws -> [ExchangePlayers] {
        do {
            let response = try await remoteActionsHandler.getExchangePlayers(id: gameID.uuidString)
            return response.compactMap({ ExchangePlayers(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .notFound = hTTPResponseError {
                    return []
                }
            }
            throw ActionsRequestError.requestError("ExchangeActions", error)
        } catch {
            throw ActionsRequestError.unexpectedError("ExchangeActions", error)
        }
    }
    
    func getAllTRFActions(gameID: UUID) async throws -> [TRF] {
        do {
            let response = try await remoteActionsHandler.getTRF(id: gameID.uuidString)
            return response.compactMap({ TRF(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .notFound = hTTPResponseError {
                    return []
                }
            }
            throw ActionsRequestError.requestError("TRFActions", error)
        } catch {
            throw ActionsRequestError.unexpectedError("TRFActions", error)
        }
    }
    
    func getAllPunishmentActions(gameID: UUID) async throws -> [Punishment] {
        do {
            let response = try await remoteActionsHandler.getPunishment(id: gameID.uuidString)
            return response.compactMap({ Punishment(body: $0) })
        } catch let error as CloudServiceError {
            if case .httpResponseError(let hTTPResponseError, _) = error {
                if case .notFound = hTTPResponseError {
                    return []
                }
            }
            throw ActionsRequestError.requestError("PunishmentActions", error)
        } catch {
            throw ActionsRequestError.unexpectedError("PunishmentActions", error)
        }
    }
    
    func getAllActionsSorted(gameID: UUID) async throws -> [ActionType] {
        var actions: [ActionType] = []
        actions.append(contentsOf: try await getAllGoalThrowActions(gameID: gameID).map({ ActionType.goalThrow($0) }))
        actions.append(contentsOf: try await getAllExchangeActions(gameID: gameID).map({ ActionType.exchange($0) })) 
        actions.append(contentsOf: try await getAllTRFActions(gameID: gameID).map({ ActionType.trf($0) }))
        actions.append(contentsOf: try await getAllPunishmentActions(gameID: gameID).map({ ActionType.punishment($0) }))
        
        return actions.sorted { $0.time < $1.time }
        
    }
    
    func deleteAction(actionID: UUID) async throws {
        
    }
}
