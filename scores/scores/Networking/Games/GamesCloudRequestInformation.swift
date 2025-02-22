import UIKit
import Foundation

// MARK: - GamesCloudRequestInformation
enum GamesCloudRequestInformation: CloudRequest {
    case createGame
    case getGames
    case searchGames
    case getGame(gameID: String)
    case updateGame(gameID: String)
    case deleteGame(gameID: String)
    case getGameByTeam(teamID: String)
}

// MARK: - baseURL
extension GamesCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api/games")!
    }
}

// MARK: - URL
extension GamesCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension GamesCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .createGame:
            return .create
        case .getGames:
            return .read
        case .searchGames:
            return .read
        case .getGame:
            return .read
        case .updateGame:
            return .modify
        case .deleteGame:
            return .delete
        case .getGameByTeam:
            return .read
        }
    }
}

// MARK: - HTTP Headers
extension GamesCloudRequestInformation {
    var headers: [HTTPHeader]? {
        return [.accept, .authorization(), .contentType(mediaType: .applicationJson)]
    }
}

extension GamesCloudRequestInformation {
    var path: String {
        switch self {
        case .createGame:
            return ""
        case .getGames:
            return ""
        case .searchGames:
            return "search"
        case .getGame(gameID: let gameID):
            return gameID
        case .updateGame(gameID: let gameID):
            return gameID
        case .deleteGame(gameID: let gameID):
            return gameID
        case .getGameByTeam(teamID: let teamID):
            return "team/\(teamID)"
        }
    }
}
