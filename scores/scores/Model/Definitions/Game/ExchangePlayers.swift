//
//  Exchange.swift
//  scores
//
//  Created by Tabea Privat on 19.02.24.
//

import Foundation

struct ExchangePlayers: Identifiable, Codable, Equatable, Hashable, Action {
    var id : UUID = UUID()
    var gameID: UUID
    var time: Int
    var selectedPlayer: Players?
    var exchangePlayer: Players
    
    init(gameID: UUID, time: Int, selectedPlayer: Players? = nil, exchangePlayer: Players) {
        self.id = UUID()
        self.gameID = gameID
        self.time = time
        self.selectedPlayer = selectedPlayer
        self.exchangePlayer = exchangePlayer
    }
    
    init?(body: ExchangePlayersBackend) {
        guard let id = UUID(uuidString: body.id),
              let gameID = UUID(uuidString: body.gameID.gameID),
              let exchangePlayer = Players(body: body.changedInPlayer),
              let selectedPlayer = Players(body: body.changedOutPlayer) else { return nil }
        self.id = id
        self.gameID = gameID
        self.time = body.time
        self.selectedPlayer = selectedPlayer
        self.exchangePlayer = exchangePlayer
    }
    
    var asCreateExchangePlayersRequestBody: CreateExchangePlayersRequestBody {
        CreateExchangePlayersRequestBody(gameID: self.gameID.uuidString,
                                         time: self.time,
                                         changedInPlayer: self.exchangePlayer.id.uuidString,
                                         changedOutPlayer: self.selectedPlayer?.id.uuidString)
    }
}
