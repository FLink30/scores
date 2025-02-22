import Foundation

struct TRF: Identifiable, Codable, Equatable, Hashable, Action {
    
    var id : UUID = UUID()
    var gameID: UUID
    var time: Int
    
    var player: Players
    var play: Play?
    
    init(gameID: UUID, time: Int, player: Players, play: Play? = nil) {
        self.id = UUID()
        self.gameID = gameID
        self.time = time
        self.player = player
        self.play = play
    }
    
    init?(body: TRFBackend) {
        guard let id = UUID(uuidString: body.id),
              let gameID = UUID(uuidString: body.gameID.gameID),
              let player = Players(body: body.player) else { return nil }
        self.id = id
        self.gameID = gameID
        self.time = body.time
        self.player = player
    }
    
    var asTRFRequestBody: CreateTRFRequestBody {
        CreateTRFRequestBody(
            gameID: self.gameID.uuidString,
            time: Int(self.time),
            playerID: self.player.id.uuidString,
            playbookID: self.play?.id.uuidString)
    }
}
