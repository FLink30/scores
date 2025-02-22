import Foundation

// MARK: - RegistrationCloudRequestHandler
final class RegistrationCloudRequestHandler: CloudRequestHandler {
    
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

// MARK: - RegistrationCloudRequestHandler implementation
extension RegistrationCloudRequestHandler: RemoteRegistrationHandler {
    func register(body: RegistrationRequestBody) async throws -> CloudIdentityRaw {
        let cloudRequest = RegistrationCloudRequestInformation.register
        let token: CloudIdentityRaw = try await cloudRequestExecuter.execute(cloudRequest, requestBody: body, queryItems: nil)
        return token
    }

 }
