import Foundation

struct TeamsRequestBody: Codable {
    let association: String
    let league: String
    let series: String
    
    enum CodingKeys: String, CodingKey {
        case association = "association"
        case league = "league"
        case series = "series"
    }
}

struct RegisterTeamsRequestBody: Codable {
    let teamName: String
    let sex: String
    let association: String
    let league: String
    let series: String
    let adminID: String?
    
    enum CodingKeys: String, CodingKey {
        case teamName = "team_name"
        case sex = "sex"
        case association = "association"
        case league = "league"
        case series = "series"
        case adminID = "admin_id"
    }
}
