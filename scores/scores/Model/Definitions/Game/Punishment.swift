import Foundation
import SwiftUI

struct Punishment: Identifiable, Equatable, Hashable, Action {
    let id : UUID
    var gameID: UUID
    var time: Int
    
    var type: PunishmentType
    var player: Players
    
    init(gameID: UUID, time: Int, type: PunishmentType, player: Players) {
        self.id = UUID()
        self.gameID = gameID
        self.time = time
        self.type = type
        self.player = player
    }
    
    init?(body: PunishmentBackend) {
        guard let id = UUID(uuidString: body.id),
              let gameID = UUID(uuidString: body.gameID.gameID),
              let player = Players(body: body.player),
              let type = body.punishmentType.asPunishmentType else { return nil }
        self.id = id
        self.gameID = gameID
        self.time = body.time
        self.player = player
        self.type = type
    }
    
    var asPunishmentRequestBody: CreatePunishmentRequestBody {
        CreatePunishmentRequestBody (
            gameID: self.gameID.uuidString,
            time: Int(self.time),
            playerID: self.player.id.uuidString,
            type: self.type.asBackendString
        )
    }
}

enum PunishmentType: String, Equatable, CaseIterable {
    case redCard = "Rote Karte"
    case yellowCard = "Gelbe Karte"
    case twoMinutes = "2 Minuten"
    
    var color: Color {
        switch self {
        case .redCard:
            return .red
        case .yellowCard:
            return .yellow
        case .twoMinutes:
            return .accentColor
        }
    }
    
    var view: AnyView {
        switch self {
        case .redCard, .yellowCard:
            return AnyView(SystemImage.card()
                .foregroundStyle(self.color))
        case .twoMinutes:
            return AnyView(Text("2")
                .foregroundStyle(self.color))
        }
    }
    
    var asBackendString: String {
        switch self {
        case .redCard:
            return "RED"
        case .yellowCard:
            return "YELLOW"
        case .twoMinutes:
            return "TWO_MINUTES"
        }
    }
}
