import Foundation

public protocol CloudRequestHandler: AnyObject {
    var cloudRequestExecuter: CloudRequestExecuter { get }
}

public protocol CloudRequestExecuter: AnyObject {
    var cloudIdentityManagementService: CloudIdentityManagementService { get }
    
    func execute<T: Codable>(_ cloudRequest: CloudRequest, requestBody: Codable?, queryItems: [URLQueryItem]?) async throws -> T
    func generateURLRequest(for cloudRequest: CloudRequest, requestBody: Codable?, queryItems: [URLQueryItem]?) async -> Result<URLRequest, CloudServiceError>
}
