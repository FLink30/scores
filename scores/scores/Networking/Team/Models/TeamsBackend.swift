import Foundation

struct TeamsGamesBackend: Codable, Equatable, Hashable {
    let teamID: String
    let teamName: String
    let sex: String
    let association: String
    let league: String
    let series: String
    
    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case teamName = "team_name"
        case association = "association"
        case league = "league"
        case series = "series"
        case sex = "sex"
    }
}

struct TeamsBackend: Codable {
    let teamID: String
    let teamName: String
    let sex: String
    let association: String
    let league: String
    let series: String
    let adminID: String?
    let games: [String]?
    let players: [String]?
    let plays: [String]?
    
    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case teamName = "team_name"
        case association = "association"
        case league = "league"
        case series = "series"
        case sex = "sex"
        case adminID = "admin_id"
        case games = "games"
        case players = "players"
        case plays = "playbooks"
    }
}

struct Teams: Identifiable, Hashable, Codable {
    let id: UUID
    var teamName: String
    var sex: Sex
    var association: Association
    var league: League
    var season: Season
    var adminID: UUID?
    var playersID: [UUID] = []
    var gamesID: [UUID] = []
    var playsID: [UUID] = []
    
    var players: [Players] = []
    var games: [Games] = []
    var playList: [Play] = []
    
    init(adminID: UUID) {
        self.id = UUID()
        self.teamName = ""
        self.sex = .female
        self.association = .unknown
        self.league = .unknown
        self.season = .unknown
        self.adminID = adminID
        self.playList = []
    }
    
    init() {
        self.id = UUID()
        self.teamName = ""
        self.sex = .female
        self.association = .unknown
        self.league = .unknown
        self.season = .unknown
        self.adminID = nil
    }
    
    init(teamName: String, sex: Sex, association: Association, league: League, season: Season, adminID: UUID?) {
        self.id = UUID()
        self.teamName = teamName
        self.sex = sex
        self.association = association
        self.league = league
        self.season = season
        self.adminID = adminID
    }
    
    init(body: TeamsBackend) {
        self.id = UUID(uuidString: body.teamID)!
        self.teamName = body.teamName
        self.sex = body.sex.asSex
        self.association = body.association.asAssociation
        self.league = body.league.asLeague
        self.season = body.series.asSeason
        if let adminID = body.adminID, let uuid = UUID(uuidString: adminID) {
            self.adminID = uuid
        } else {
            adminID = nil
        }
        if let games = body.games {
            for game in games {
                if let uuid = UUID(uuidString: game) {
                    self.gamesID.append(uuid)
                }
            }
        } else {
            self.games = []
        }
        
        if let players = body.players {
            for player in players {
                if let uuid = UUID(uuidString: player) {
                    self.playersID.append(uuid)
                }
            }
        } else {
            self.players = []
        }
        
        if let plays = body.plays {
            for play in plays {
                if let uuid = UUID(uuidString: play) {
                    self.playsID.append(uuid)
                }
            }
        } else {
            self.playList = []
        }
        
    }
    
    init(body: CreateTeamsResponseBody) {
        self.id = UUID(uuidString: body.teamID)!
        self.teamName = body.teamName
        self.sex = body.sex.asSex
        self.association = body.association.asAssociation
        self.league = body.league.asLeague
        self.season = body.series.asSeason
        if let adminID = body.adminID, let uuid = UUID(uuidString: adminID.userID) {
            self.adminID = uuid
        } else {
            adminID = nil
        }
    }
    
    var asRegisterRequestBody: RegisterTeamsRequestBody {
        return RegisterTeamsRequestBody(teamName: self.teamName,
                                        sex: self.sex.asBackendString,
                                        association: self.association(),
                                        league: self.league(),
                                        series: self.season(),
                                        adminID: self.adminID?.uuidString.lowercased())
    }
    
    var asRequestBody: TeamsBackend {
        return TeamsBackend(teamID: self.id.uuidString,
                            teamName: self.teamName,
                            sex: self.sex.asBackendString,
                            association: self.association(),
                            league: self.league(),
                            series: self.season(),
                            adminID: self.adminID?.uuidString,
                            games: self.gamesID.map({ $0.uuidString }),
                            players: self.playersID.map({ $0.uuidString }),
                            plays: self.playsID.map({ $0.uuidString }))
    }
    
    var asTeamsGamesBackend: TeamsGamesBackend {
        return TeamsGamesBackend(teamID: self.id.uuidString, 
                                 teamName: self.teamName,
                                 sex: self.sex.asBackendString,
                                 association: self.association.asBackendString,
                                 league: self.league(),
                                 series: self.season())
    }
    
    static func == (lhs: Teams, rhs: Teams) -> Bool {
        lhs.id == rhs.id
    }
}

struct CreateTeamsResponseBody: Codable, Equatable, Hashable {
    let teamID: String
    let teamName: String
    let sex: String
    let association: String
    let league: String
    let series: String
    let adminID: UserID?

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case teamName = "team_name"
        case association = "association"
        case league = "league"
        case series = "series"
        case sex = "sex"
        case adminID = "admin_id"
    }
}

struct UserID: Codable, Equatable, Hashable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}
