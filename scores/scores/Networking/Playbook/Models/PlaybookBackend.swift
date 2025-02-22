import Foundation

struct PlaybookBackend: Codable {
    let id: String
    let name : String
    let color: String
    let teamID: TeamID
    
    enum CodingKeys: String, CodingKey {
        case id = "playbook_id"
        case name = "name"
        case color = "hex_value"
        case teamID = "team_id"
    }
}

struct Play: Identifiable, Equatable, Hashable, Codable {
    var id : UUID = UUID()
    var name: String
    var teamID: UUID
    var color: String
    
    init(name: String, color: String) {
        self.id = UUID()
        self.name = name
        self.teamID = UUID()
        self.color = color
    }
    
    init?(body: PlaybookBackend) {
        guard let id = UUID(uuidString: body.id), let teamID = UUID(uuidString: body.teamID.teamID) else { return nil}
        self.id = id
        self.name = body.name
        self.teamID = teamID
        self.color = body.color
    }
    
    var asPlaybookBackend: PlaybookBackend {
        PlaybookBackend(
            id: self.id.uuidString,
            name: self.name,
            color: self.color,
            teamID: TeamID(teamID: self.teamID.uuidString))
    }
    
    var asCreatePlaybookRequestBody: CreatePlaybookRequestBody {
        CreatePlaybookRequestBody(
            name: self.name,
            color: self.color,
            teamID: self.teamID.uuidString)
    }
}
