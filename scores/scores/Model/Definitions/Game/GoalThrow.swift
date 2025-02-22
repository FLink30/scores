//
//  GoalThrow.swift
//  scores
//
//  Created by Tabea Privat on 20.01.24.
//

import Foundation

struct GoalThrow: Identifiable, Codable, Equatable, Hashable, Action {
    
    var id : UUID
    var gameID: UUID
    var time: Int
    
    var players: [Players]
    var play: Play?
    var goal: Bool
    var scorer: Players
    var throwingTarget: Int
    
    init(gameID: UUID, time: Int, players: [Players], play: Play, goal: Bool, scorer: Players, throwingTarget: Int) {
        self.id = UUID()
        self.gameID = gameID
        self.time = time
        self.players = players
        self.play = play
        self.goal = goal
        self.scorer = scorer
        self.throwingTarget = throwingTarget
    }
    
    init?(body: GoalThrowBackend) {
        guard let id = UUID(uuidString: body.id),
                let gameID = UUID(uuidString: body.gameID.gameID),
              let scorer = Players(body: body.scorer) else { return nil }
        self.id = id
        self.gameID = gameID
        self.time = body.time
        self.players = body.players.compactMap({ Players(body: $0) })
        self.goal = body.goal
        self.scorer = scorer
        self.throwingTarget = body.throwingTarget
    }
    
    var asGoalThrowRequestBody: CreateGoalThrowRequestBody? {
        guard let playID = self.play?.id.uuidString else { return nil }
        return CreateGoalThrowRequestBody(
            gameID: self.gameID.uuidString,
            time: Int(self.time),
            players: self.players.map({ $0.id.uuidString }),
            playID: playID,
            goal: self.goal,
            scorer: self.scorer.id.uuidString,
            throwingTarget: self.throwingTarget)
    }
}
