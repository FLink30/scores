//
//  GameListItemView.swift
//  scores
//
//  Created by Franziska Link on 06.01.24.
//

import SwiftUI

struct GameListItemView: View {
    
    var game: Games
    var lastGame: Bool
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: game.gameStart)
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: game.gameStart)
    }
    var color: Color {
        lastGame ? Color.secondary : Color.primary
    }
    var goalsHomeTeam: String {
        if let points = game.homePoints, lastGame {
            "\(points)"
        } else {
            "-"
        }
    }
    var goalsOpponent: String {
        if let points = game.opponentPoints, lastGame {
            "\(points)"
        } else {
            "-"
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(.background.tertiary)
                        
                        SystemImage.person()
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: 60, maxHeight: 60)
                    
                    Text(game.homeTeam.teamName)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 100)
                
                Spacer()
                
                VStack(spacing: Padding.small()) {
                    if lastGame {
                        Text("\(goalsHomeTeam) : \(goalsOpponent)")
                            .font(.system(size: 30))
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("\(game.location)")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(date)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 20))
                        Text("\(time)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 20))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)
                
                VStack {
                    ZStack(alignment: .bottom, content: {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(.background.tertiary)
                            
                            SystemImage.person()
                                .font(.system(size: 30))
                            
                        }
                        .frame(maxWidth: 60, maxHeight: 60)
                    })
                    Text(game.opponentTeam.teamName)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 100)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background.secondary)
            )
        }
    }
}
//    
//
//#Preview {
//    let lastGame = Game.createGame()
//    return GameListItemView(game: lastGame, lastGame: false)
//    
//}
