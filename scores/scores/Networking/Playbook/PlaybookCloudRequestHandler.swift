import Foundation

// MARK: - PlaybookCloudRequestHandler
final class PlaybookCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - PlaybookCloudRequestHandler implementation
extension PlaybookCloudRequestHandler: RemotePlaybookHandler {
    func createPlaybook(body: CreatePlaybookRequestBody) async throws -> PlaybookBackend {
        let cloudRequest = PlaybookCloudRequestInformation.create
        let response: PlaybookBackend  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
        return response
    }
    
    func getPlaybooks(id: String) async throws -> [PlaybookBackend] {
        let cloudRequest = PlaybookCloudRequestInformation.get(id: id)
        let response: [PlaybookBackend]  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func deletePlaybook(id: String) async throws -> String {
        let cloudRequest = PlaybookCloudRequestInformation.delete(id: id)
        let response: String  = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
 }
