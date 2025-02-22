import Foundation

struct PunishmentBackend: Codable {
    let id : String
    let gameID: GamesActionsBackend
    let time: Int
    let player: PlayersBackend
    let punishmentType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "punishment_action_id"
        case gameID = "game_id"
        case time = "time_stamp"
        case player = "player_id"
        case punishmentType = "punishment_type"
    }
}

struct CreatePunishmentRequestBody: Codable {
    let gameID: String
    let time: Int
    let playerID: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case time = "time_stamp"
        case playerID = "player_id"
        case type = "punishment_type"
    }
}

struct CreatePunishmentResponseBody: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "punishment_action_id"
    }
}

