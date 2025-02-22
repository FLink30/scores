import Foundation

struct CreateGamesRequestBody: Codable {
    let homeGame: Bool
    let gameStart: String
    let location: String
    let homeTeamID: String
    let opponentTeamID: String
    
    enum CodingKeys: String, CodingKey {
        case homeGame = "home_game"
        case gameStart = "game_start"
        case location = "location"
        case homeTeamID = "own_team_id"
        case opponentTeamID = "enemy_team_id"
    }
}

struct UpdateGamesRequestBody: Codable {
    var homePoints: Int?
    var opponentPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case homePoints = "own_points"
        case opponentPoints = "enemy_points"
    }
}

struct GamesRequestBody: Codable {
    let gameID: String
    let homeGame: Bool
    let gameStart: String
    let location: String
    let homeTeamID: String
    let opponentTeamID: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case homeGame = "home_game"
        case gameStart = "game_start"
        case location = "location"
        case homeTeamID = "own_team_id"
        case opponentTeamID = "enemy_team_id"
    }
}
