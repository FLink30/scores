import UIKit
import Foundation

// MARK: - PlaybookCloudRequestInformation
enum PlaybookCloudRequestInformation: CloudRequest {
    case create
    case get(id: String)
    case delete(id: String)
}

// MARK: - baseURL
extension PlaybookCloudRequestInformation {
    var baseURL: URL {
        return URL(string: "http://localhost:3000/api/playbooks")!
    }
}

// MARK: - URL
extension PlaybookCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension PlaybookCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .create:
            return .create
        case .get:
            return .read
        case .delete:
            return .delete
        }
    }
}

// MARK: - HTTP Headers
extension PlaybookCloudRequestInformation {
    var headers: [HTTPHeader]? {
        return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
    }
}

extension PlaybookCloudRequestInformation {
    var path: String {
        switch self {
        case .create:
            return ""
        case .get(id: let id):
            return id
        case .delete(id: let id):
            return id
        }
    }
}
