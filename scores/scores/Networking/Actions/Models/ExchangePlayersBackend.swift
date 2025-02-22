import Foundation

struct ExchangePlayersBackend: Codable {
    let id : String
    let gameID: GamesActionsBackend
    let time: Int
    let changedInPlayer: PlayersBackend
    let changedOutPlayer: PlayersBackend?
    
    enum CodingKeys: String, CodingKey {
        case id = "change_action_id"
        case gameID = "game_id"
        case time = "time_stamp"
        case changedInPlayer = "changed_in_player"
        case changedOutPlayer = "changed_out_player"
    }
}

struct CreateExchangePlayersRequestBody: Codable {
    let gameID: String
    let time: Int
    let changedInPlayer: String
    let changedOutPlayer: String?
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case time = "time_stamp"
        case changedInPlayer = "changed_in_player"
        case changedOutPlayer = "changed_out_player"
    }
}

struct CreateExchangePlayersResponseBody: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "change_action_id"
    }
}

