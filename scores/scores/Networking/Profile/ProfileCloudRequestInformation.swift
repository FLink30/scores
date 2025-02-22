import UIKit
import Foundation

// MARK: - ProfileCloudRequestInformation
enum ProfileCloudRequestInformation: CloudRequest {
    case profile
    case user
}

// MARK: - baseURL
extension ProfileCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api")!
    }
}

// MARK: - URL
extension ProfileCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension ProfileCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .profile:           return .read
        case .user: return .read
        }
    }
}

// MARK: - HTTP Headers
extension ProfileCloudRequestInformation {
    var headers: [HTTPHeader]? {
        switch self {
        case .profile, .user:
            return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
        }
    }
}

extension ProfileCloudRequestInformation {
    var path: String {
        switch self {
        case .profile:           return "auth/profile"
        case .user:           return "users"
        }
    }
}
