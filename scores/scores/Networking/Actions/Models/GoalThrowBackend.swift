import Foundation

struct GoalThrowBackend: Codable {
    let id : String
    let gameID: GamesActionsBackend
    let time: Int
    let players: [ActionsPlayersBackend]
    let goal: Bool
    let scorer: ActionsPlayersBackend
    let throwingTarget: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "throw_action_id"
        case gameID = "game_id"
        case time = "time_stamp"
        case players = "involved_players"
        case goal = "goal"
        case scorer = "shooter"
        case throwingTarget = "target"
    }
}

struct CreateGoalThrowRequestBody: Codable {
    let gameID: String
    let time: Int
    let players: [String]
    let playID: String
    let goal: Bool
    let scorer: String
    let throwingTarget: Int
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case time = "time_stamp"
        case players = "involved_players"
        case playID = "playbook_id"
        case goal = "goal"
        case scorer = "shooter"
        case throwingTarget = "target"
    }
}

struct CreateGoalThrowResponseBody: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "throw_action_id"
    }
}
