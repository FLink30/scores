import UIKit
import Foundation

// MARK: - ActionsCloudRequestInformation
enum ActionsCloudRequestInformation: CloudRequest {
    case create(type: ActionTypeBackend)
    case get(type: ActionTypeBackend, id: String)
    case delete(type: ActionTypeBackend, id: String)
}

// MARK: - baseURL
extension ActionsCloudRequestInformation {
    var baseURL: URL {
        switch self {
        case .create(let type), .get(let type, _), .delete(let type, _):
            switch type {
            case .goalThrow:
                return URL(string: "http://localhost:3000/api/throw-actions")!
            case .trf:
                return URL(string: "http://localhost:3000/api/trf-actions")!
            case .punishment:
                return URL(string: "http://localhost:3000/api/punishment-actions")!
            case .exchange:
                return URL(string: "http://localhost:3000/api/change-actions")!
            }
        }
    }
}

// MARK: - URL
extension ActionsCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension ActionsCloudRequestInformation {
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
extension ActionsCloudRequestInformation {
    var headers: [HTTPHeader]? {
        return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
    }
}

extension ActionsCloudRequestInformation {
    var path: String {
        switch self {
        case .create:
            return ""
        case .get(type: _, id: let id):
            return id
        case .delete(type: _, id: let id):
            return id
        }
    }
}
