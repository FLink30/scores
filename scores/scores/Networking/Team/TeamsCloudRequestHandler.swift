import Foundation

// MARK: - TeamsCloudRequestHandler
final class TeamsCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - TeamsCloudRequestHandler implementation
extension TeamsCloudRequestHandler: RemoteTeamsHandler {
    
    func findTeams(parameter: [TeamsParameter]) async throws -> [TeamsBackend] {
        let cloudRequest = TeamsCloudRequestInformation.findAll
        let response: [TeamsBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: parameter.map({ $0.asQueryItem }))
        return response
    }
    
    func getTeamByID(id: String) async throws -> TeamsBackend {
        let cloudRequest = TeamsCloudRequestInformation.getTeam(id: id)
        let response: TeamsBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func deleteTeam(id: String) async throws -> String {
        let cloudRequest = TeamsCloudRequestInformation.deleteTeam(id: id)
        let response: String  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getTeamByID(adminID: String) async throws -> TeamsBackend {
        let cloudRequest = TeamsCloudRequestInformation.findOneByAdmin(id: adminID)
        let response: TeamsBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func registerTeam(requestBody: RegisterTeamsRequestBody) async throws -> CreateTeamsResponseBody {
        let cloudRequest = TeamsCloudRequestInformation.register
        let response: CreateTeamsResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
        return response
    }
    
    func updateTeam(requestBody: TeamsBackend) async throws -> TeamsBackend {
        let cloudRequest = TeamsCloudRequestInformation.update
        let response: TeamsBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: requestBody, queryItems: nil)
        return response
    }
    
 }
