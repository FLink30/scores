import Foundation

// MARK: - ActionsCloudRequestHandler
final class ActionsCloudRequestHandler: CloudRequestHandler {
    
    // MARK: - Accessible Properties
    private(set) var cloudRequestExecuter: CloudRequestExecuter
    
    // MARK: - Init
    init() {
        self.cloudRequestExecuter = CloudServiceManager.shared.commonRequestExecuter
    }
    
    init(cloudRequestExecuter: CloudRequestExecuter) {
        self.cloudRequestExecuter = cloudRequestExecuter
    }
}

// MARK: - ActionsCloudRequestHandler implementation
extension ActionsCloudRequestHandler: RemoteActionsHandler {
    func createAction(type: CreateActionBackend) async throws -> String {
        let cloudRequest = ActionsCloudRequestInformation.create(type: type.actionTypeBackend)
        switch type {
        case .goalThrow(let body):
            let response: CreateGoalThrowResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
            return response.id
        case .trf(let body):
            let response: CreateTRFResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
            return response.id
        case .punishment(let body):
            let response: CreatePunishmentResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
            return response.id
        case .exchange(let body):
            let response: CreateExchangePlayersResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
            return response.id
        }
    }
    
    func getGoalThrow(id: String) async throws -> [GoalThrowBackend] {
        let cloudRequest = ActionsCloudRequestInformation.get(type: .goalThrow, id: id)
        let response: [GoalThrowBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getExchangePlayers(id: String) async throws -> [ExchangePlayersBackend] {
        let cloudRequest = ActionsCloudRequestInformation.get(type: .exchange, id: id)
        let response: [ExchangePlayersBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getTRF(id: String) async throws -> [TRFBackend] {
        let cloudRequest = ActionsCloudRequestInformation.get(type: .trf, id: id)
        let response: [TRFBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getPunishment(id: String) async throws -> [PunishmentBackend] {
        let cloudRequest = ActionsCloudRequestInformation.get(type: .punishment, id: id)
        let response: [PunishmentBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func deleteAction(actionID: UUID) async throws {
        
    }

 }
