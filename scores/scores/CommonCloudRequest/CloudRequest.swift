import Foundation

public protocol CloudRequest {
    var url: URL { get }
    var operation: CloudOperation { get }
    var headers: [HTTPHeader]? { get }
    var path: String { get }
}

// MARK: - Computed Properties
extension CloudRequest {
    /// The url to use when executing the request.
    var urlRequest: URLRequest? {
        return URLRequest(url: url)
    }
}

// MARK: - Debugging Properties
extension CloudRequest {
    /// Used for logging
    var description: String {
        return "\(operation.httpMethod) \(Self.self).\(self) \(absoluteURLString)"
    }
    
    /// Used for logging
    var shortDescription: String {
        return "\(operation.httpMethod) \(Self.self).\(self)"
    }
    
    var absoluteURLString: String {
        return "URL: \(url.absoluteString)"
    }
}
