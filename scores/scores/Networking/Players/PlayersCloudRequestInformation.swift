import UIKit
import Foundation

// MARK: - PlayersCloudRequestInformation
enum PlayersCloudRequestInformation: CloudRequest {
    case createPlayer
    case getPlayers
    case getPlayer(playerID: String)
    case updatePlayer(playerID: String)
    case deletePlayer(playerID: String)
}

// MARK: - baseURL
extension PlayersCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api/players")!
    }
}

// MARK: - URL
extension PlayersCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension PlayersCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .createPlayer:
            return .create
        case .getPlayers:
            return .read
        case .getPlayer:
            return .read
        case .updatePlayer:
            return .modify
        case .deletePlayer:
            return .delete
        }
    }
}

// MARK: - HTTP Headers
extension PlayersCloudRequestInformation {
    var headers: [HTTPHeader]? {
        return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
    }
}

extension PlayersCloudRequestInformation {
    var path: String {
        switch self {
        case .createPlayer:
            return ""
        case .getPlayers:
            return ""
        case .getPlayer(let playerID):
            return playerID
        case .updatePlayer(let playerID):
            return playerID
        case .deletePlayer(let playerID):
            return playerID
        }
    }
}
