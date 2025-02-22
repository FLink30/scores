import Foundation

// MARK: - PlayersCloudRequestHandler
final class PlayersCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - PlayersCloudRequestHandler implementation
extension PlayersCloudRequestHandler: RemotePlayersHandler {
    
    func createPlayer(requestBody: CreatePlayersRequestBody) async throws -> CreatePlayersResponseBody {
        let cloudRequest = PlayersCloudRequestInformation.createPlayer
        let response: CreatePlayersResponseBody  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
        return response
    }
    
    func getPlayers(parameter: [GamesParameter]) async throws -> [PlayersBackend] {
        let cloudRequest = PlayersCloudRequestInformation.getPlayers
        let response: [PlayersBackend] = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: parameter.map({ $0.asQueryItem }))
        return response
    }
    
    func getPlayer(playerID: String) async throws -> PlayersBackend {
        let cloudRequest = PlayersCloudRequestInformation.getPlayer(playerID: playerID)
        let response: PlayersBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    
    func deletePlayer(playerID: String) async throws -> String {
        let cloudRequest = PlayersCloudRequestInformation.deletePlayer(playerID: playerID)
        let response: String  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func updatePlayer(requestBody: PlayersBackend) async throws {
        let cloudRequest = PlayersCloudRequestInformation.updatePlayer(playerID: requestBody.playerID)
        let _ : String = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
    }
 }
