import Foundation

enum MockCloudIdentityRefreshCloudRequestInformation: CloudRequest {
    case refreshCloudIdentity
    case validateToken
}

// MARK: - URL
extension MockCloudIdentityRefreshCloudRequestInformation {
    var url: URL {
        guard let url = URL(string: "https://apple.com") else {
/// NO HANDLING IN FATAL ERROR: MOC
                      fatalError("Could not create url")
        }
        return url.appendingPathComponent("v1").appendingPathComponent(path)
    }
}

// MARK: - CloudOperation
extension MockCloudIdentityRefreshCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .refreshCloudIdentity:           return .create
        case .validateToken:                  return .create
        }
    }
}

// MARK: - HTTP Headers
extension MockCloudIdentityRefreshCloudRequestInformation {
    var headers: [HTTPHeader]? {
        switch self {
        case .refreshCloudIdentity:
            return [.deviceIdentifier(UUID().uuidString)]
        case .validateToken:
            return []
        }
    }
}

// MARK: - Path
extension MockCloudIdentityRefreshCloudRequestInformation {
    var path: String {
        switch self {
        case .refreshCloudIdentity:           return "login/refresh"
        case .validateToken:                  return "validate"
        }
    }
}
