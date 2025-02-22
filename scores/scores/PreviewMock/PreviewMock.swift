////
////  PreviewMock.swift
////  scores
////
////  Created by Franziska Link on 10.01.24.
////
//
//import Foundation
//
//  Created by Franziska Link on 10.01.24.
//

import Foundation

struct PreviewMock {
    
    static let game = Game(homeTeam: "Mannheim",
                           opponent: "Stuttgart",
                           location: "Mannheim",
                           dateTime: DateComponents(year: 2023, month: 10, day: 10, hour: 20, minute: 00, second: 00),
                           goalsHomeTeam: 2,
                           goalsOpponent: 1)
    
    
    static func createGamesList() -> [Game] {
        return [Game(homeTeam: "Mannheim",
                     opponent: "Stuttgart",
                     location: "Mannheim",
                     dateTime: DateComponents(year: 2023, month: 10, day: 10, hour: 20, minute: 00, second: 00),
                     goalsHomeTeam: 2,
                     goalsOpponent: 1),
                Game(homeTeam: "Mannheim",
                     opponent: "Hamburg",
                     location: "Mannheim",
                     dateTime: DateComponents(year: 2023, month: 11, day: 10, hour: 20, minute: 00, second: 00),
                     goalsHomeTeam: 2,
                     goalsOpponent: 1),
                Game(homeTeam: "Mannheim",
                     opponent: "Stuttgart",
                     location: "Mannheim",
                     dateTime: DateComponents(year: 2024, month: 10, day: 10, hour: 20, minute: 00, second: 00),
                     goalsHomeTeam: 0,
                     goalsOpponent: 0),
                Game(homeTeam: "Mannheim",
                     opponent: "Hamburg",
                     location: "Mannheim",
                     dateTime: DateComponents(year: 2024, month: 11, day: 10, hour: 20, minute: 00, second: 00),
                     goalsHomeTeam: 2,
                     goalsOpponent: 1)
        ]
    }
    
    static func createUser() -> User {
        return User(id: UUID(),
                    firstName: "Hans",
                    lastName: "Müller",
                    email: "HansMüller@freenet.de")
    }
    
    
    static func createTeam() -> Team {
        let user = createUser()
        
        let gamesList = createGamesList()
        
        return Team(name: "Stuttgart",
                    sex: Sex.male,
                    league: League.league1,
                    association: Association.association1,
                    season: Season.a,
                    admin: user,
                    gamesList: gamesList)
    }
    
    static func createPlayer() -> Player {
        let team = createTeam()
        
        return Player(id: UUID(),
                      firstName: "Max",
                      lastName: "Müller",
                      positionAttack: PositionAttack.stürmer,
                      positionDefense: PositionDefense.torwart,
                      number: 14,
                      team: team)
    }
}
