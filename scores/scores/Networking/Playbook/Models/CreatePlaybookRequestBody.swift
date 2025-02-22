import Foundation

struct CreatePlaybookRequestBody: Codable {
    let name : String
    let color: String
    let teamID: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case color = "hex_value"
        case teamID = "team_id"
    }
}
