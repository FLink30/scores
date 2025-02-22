import Foundation

struct TRFBackend: Codable {
    let id : String
    let gameID: GamesActionsBackend
    let time: Int
    let player: PlayersBackend
    
    enum CodingKeys: String, CodingKey {
        case id = "trf_action_id"
        case gameID = "game_id"
        case time = "time_stamp"
        case player = "player_id"
    }
}

struct CreateTRFRequestBody: Codable {
    let gameID: String
    let time: Int
    let playerID: String
    let playbookID: String?
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case time = "time_stamp"
        case playerID = "player_id"
        case playbookID = "playbook_id"
    }
}

struct CreateTRFResponseBody: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "trf_action_id"
    }
}

