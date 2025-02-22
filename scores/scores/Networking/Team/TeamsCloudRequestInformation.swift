import UIKit
import Foundation

// MARK: - TeamsCloudRequestInformation
enum TeamsCloudRequestInformation: CloudRequest {
    case findAll
    case getTeam(id: String)
    case deleteTeam(id: String)
    case findOneByAdmin(id: String)
    case register
    case update
}

// MARK: - baseURL
extension TeamsCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api/teams")!
    }
}

// MARK: - URL
extension TeamsCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension TeamsCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .findAll:
            return .read
        case .getTeam:
            return .read
        case .deleteTeam:
            return .delete
        case .findOneByAdmin:
            return .read
        case .register:
            return .create
        case .update:
            return .update
        }
    }
}

// MARK: - HTTP Headers
extension TeamsCloudRequestInformation {
    var headers: [HTTPHeader]? {
        switch self {
        case .findAll:
            return [.accept, .contentType(mediaType: .applicationJson)]
        case .getTeam:
            return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
        case .deleteTeam:
            return [.accept, .authorization()]
        case .findOneByAdmin:
            return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
        case .register:
            return [.accept, .contentType(mediaType: .applicationJson)]
        case .update:
            return [.accept, .contentType(mediaType: .applicationJson)]
        }
    }
}

extension TeamsCloudRequestInformation {
    var path: String {
        switch self {
        case .findAll:
            return "find"
        case .getTeam(let id):
            return id
        case .deleteTeam(let id):
            return id
        case .findOneByAdmin(let id):
            return "find-one-by-admin/\(id)"
        case .register:
            return "register"
        case .update:
            return ""
        }
    }
}
