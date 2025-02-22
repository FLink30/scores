import Foundation

struct CreatePlayersRequestBody: Codable {
    let firstName: String
    let lastName: String
    let positionOffensive: String
    let positionDefensive: String
    let number: Int
    let teamID: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case positionOffensive = "pos_offense"
        case positionDefensive = "pos_defensive"
        case number = "jersey_number"
        case teamID = "team_id"
    }
}
