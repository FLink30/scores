import Foundation

struct GamesBackend: Codable {
    let gameID: String
    let homeGame: Bool
    let location: String
    let homePoints: Int?
    let opponentPoints: Int?
    let gameStart: String
    let opponentTeam: TeamsGamesBackend
    let homeTeam: TeamsGamesBackend
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case homeGame = "home_game"
        case location = "location"
        case homePoints = "own_points"
        case opponentPoints = "enemy_points"
        case gameStart = "game_start"
        case opponentTeam = "enemy_team"
        case homeTeam = "own_team"
    }
}

struct UpdateGamesResponseBody: Codable {
    let gameID: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "id"
    }
}

struct GamesActionsBackend: Codable {
    let gameID: String
    let homeGame: Bool
    let location: String
    let ownPoints: Int?
    let enemyPoints: Int?
    let gameStart: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case homeGame = "home_game"
        case location = "location"
        case ownPoints = "own_points"
        case enemyPoints = "enemy_points"
        case gameStart = "game_start"
    }
}

struct Games: Identifiable, Hashable, Codable {
    
    let id: UUID
    var homeGame: Bool
    var gameStart: Date
    var location: String
    var homePoints: Int?
    var opponentPoints: Int?
    var homeTeam: TeamsGamesBackend
    var opponentTeam: TeamsGamesBackend
    
    var activeHomeTeamPlayerList: [Players] = []
    var opponentTeamPlayerList: [Players] = []
    
    var players: [Players] = []
    var playbook: [Play] = []
    
    init(homeGame: Bool, gameStart: Date, location: String, homePoints: Int?, opponentPoints: Int?, homeTeam: TeamsGamesBackend, opponentTeam: TeamsGamesBackend) {
        self.id = UUID()
        self.homeGame = homeGame
        self.gameStart = gameStart
        self.location = location
        self.homePoints = homePoints
        self.opponentPoints = opponentPoints
        self.homeTeam = homeTeam
        self.opponentTeam = opponentTeam
    }
    
    init?(body: GamesBackend) {
        guard let uuid = UUID(uuidString: body.gameID) else {
            return nil
        }
        guard let date = body.gameStart.asBackendDate else {
            return nil
        }
        
        self.id = uuid
        self.homeGame = body.homeGame
        self.gameStart = date
        self.location = body.location
        self.homePoints = body.homePoints
        self.opponentPoints = body.opponentPoints
        self.homeTeam = body.homeTeam
        self.opponentTeam = body.opponentTeam
    }
    
    init?(body: CreateGamesResponseBody, homeTeam: TeamsGamesBackend, opponentTeam: TeamsGamesBackend) {
        guard let uuid = UUID(uuidString: body.gameID) else { return nil }
        guard let date = body.gameStart.asBackendDate else { return nil }
        
        self.id = uuid
        self.homeGame = body.homeGame
        self.gameStart = date
        self.location = body.location
        self.homePoints = body.homePoints
        self.opponentPoints = body.opponentPoints
        self.homeTeam = homeTeam
        self.opponentTeam = opponentTeam
    }
    
    var asCreateGamesRequestBody: CreateGamesRequestBody {
        return CreateGamesRequestBody(
            homeGame: self.homeGame,
            gameStart: self.gameStart.asBackendString,
            location: self.location,
            homeTeamID: self.homeTeam.teamID,
            opponentTeamID: self.opponentTeam.teamID
        )
    }
    
    var asUpdateGamesRequestBody: UpdateGamesRequestBody {
        return UpdateGamesRequestBody(
            homePoints: self.homePoints ?? 0,
            opponentPoints: self.opponentPoints ?? 0
        )
    }

}
