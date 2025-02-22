import Foundation

struct PlayersBackend: Codable {
    let playerID: String
    let firstName: String
    let lastName: String
    let positionOffensive: String
    let positionDefensive: String?
    let number: Int
    let teamID: String?
    
    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case positionOffensive = "pos_offense"
        case positionDefensive = "pos_defensive"
        case number = "jersey_number"
        case teamID = "team"
    }
}

struct ActionsPlayersBackend: Codable {
    let playerID: String
    let firstName: String
    let lastName: String
    let positionOffensive: String
    let positionDefensive: String?
    let number: Int
    
    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case positionOffensive = "pos_offense"
        case positionDefensive = "pos_defensive"
        case number = "jersey_number"
    }
}

struct Players: Identifiable, Equatable, Hashable, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var positionAttack: PositionAttack
    var number: Int
    var teamID: UUID?
    
    init(teamID: UUID) {
        self.id = UUID()
        self.firstName = ""
        self.lastName = ""
        self.positionAttack = .torhüter
        self.number = 0
        self.teamID = teamID
    }
    
    init?(body: PlayersBackend?) {
        guard let body else { return nil }
        guard let playerID = UUID(uuidString: body.playerID) else {
            return nil
        }
        if let id = body.teamID, let teamID = UUID(uuidString: id) {
            self.teamID = teamID
        }
        self.id = playerID
        self.firstName = body.firstName
        self.lastName = body.lastName
        self.positionAttack = body.positionOffensive.asPosition
        self.number = body.number
    }
    
    init?(body: ActionsPlayersBackend?) {
        guard let body else { return nil }
        guard let playerID = UUID(uuidString: body.playerID) else {
            return nil
        }
        self.id = playerID
        self.firstName = body.firstName
        self.lastName = body.lastName
        self.positionAttack = body.positionOffensive.asPosition
        self.number = body.number
    }
    
    init?(body: CreatePlayersResponseBody) {
        guard let playerID = UUID(uuidString: body.playerID) else {
            return nil
        }
        if let teamID = UUID(uuidString: body.teamID.teamID) {
            self.teamID = teamID
        }
        self.id = playerID
        self.firstName = body.firstName
        self.lastName = body.lastName
        self.positionAttack = body.positionOffensive.asPosition
        self.number = body.number
    }
    
    var asCreatePlayersRequestBody: CreatePlayersRequestBody {
        CreatePlayersRequestBody(
            firstName: self.firstName,
            lastName: self.lastName,
            positionOffensive: self.positionAttack(),
            positionDefensive: PositionAttack.torhüter(),
            number: self.number,
            teamID: self.teamID?.uuidString
        )
    }
    
    var asRequestBody: PlayersBackend {
        PlayersBackend(
            playerID: self.id.uuidString,
            firstName: self.firstName,
            lastName: self.lastName,
            positionOffensive: self.positionAttack(),
            positionDefensive: PositionAttack.torhüter(),
            number: self.number,
            teamID: self.teamID?.uuidString
        )
    }
}

struct CreatePlayersResponseBody: Codable {
    let playerID: String
    let firstName: String
    let lastName: String
    let positionOffensive: String
    let positionDefensive: String?
    let number: Int
    let teamID: TeamID
    
    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case positionOffensive = "pos_offense"
        case positionDefensive = "pos_defensive"
        case number = "jersey_number"
        case teamID = "team"
    }
}

struct TeamID: Codable {
    let teamID: String
    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
    }
}
