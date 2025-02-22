import Foundation

// MARK: - ProfileCloudRequestHandler
final class ProfileCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - ProfileCloudRequestHandler implementation
extension ProfileCloudRequestHandler: RemoteProfileHandler {
    func retrieveProfile() async throws -> TokenDetails {
        let cloudRequest = ProfileCloudRequestInformation.profile
        let response: TokenDetails = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
    
    func getProfile() async throws -> ProfileResponseBody {
        let cloudRequest = ProfileCloudRequestInformation.user
        let response: ProfileResponseBody = try await cloudRequestExecuter.execute(cloudRequest, requestBody: nil, queryItems: nil)
        return response
    }
 }
