import Foundation

struct CreateGamesResponseBody: Codable {
    let gameID: String
    let homeGame: Bool
    let gameStart: String
    let location: String
    let homePoints: Int?
    let opponentPoints: Int?
    let homeTeamID: String
    let opponentTeamID: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case homeGame = "home_game"
        case gameStart = "game_start"
        case location = "location"
        case homePoints = "own_points"
        case opponentPoints = "enemy_points"
        case homeTeamID = "own_team_id"
        case opponentTeamID = "enemy_team_id"
    }
}
