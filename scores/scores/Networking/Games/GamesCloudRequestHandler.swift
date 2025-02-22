import Foundation

// MARK: - GamesCloudRequestHandler
final class GamesCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - GamesCloudRequestHandler implementation
extension GamesCloudRequestHandler: RemoteGamesHandler {
    func createGame(requestBody: CreateGamesRequestBody) async throws -> CreateGamesResponseBody {
        let cloudRequest = GamesCloudRequestInformation.createGame
        let response: CreateGamesResponseBody  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
        return response
    }
    
    func getGameByID(gamesID: String) async throws -> GamesBackend {
        let cloudRequest = GamesCloudRequestInformation.getGame(gameID: gamesID)
        let response: GamesBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getGamesByTeamID(teamID: String, parameter: [GamesParameter]) async throws -> [GamesBackend] {
        let cloudRequest = GamesCloudRequestInformation.getGameByTeam(teamID: teamID)
        let response: [GamesBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: parameter.map({ $0.asQueryItem }))
        return response
    }
    
    func deleteGame(gamesID: String) async throws -> String {
        let cloudRequest = GamesCloudRequestInformation.deleteGame(gameID: gamesID)
        let response: String  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func updateGame(gameID: String, requestBody: UpdateGamesRequestBody) async throws -> UpdateGamesResponseBody {
        let cloudRequest = GamesCloudRequestInformation.updateGame(gameID: gameID)
        let response: UpdateGamesResponseBody  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
        return response
    }
 }
