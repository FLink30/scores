//
//  TimerView.swift
//  scores
//
//  Created by Tabea Privat on 12.01.24.
//

import Foundation
import SwiftUI

struct FieldView: View {
    
    var players: [Players]
    var actionForPlayer: (Players) -> ()
    var actionForPosition: ((PositionAttack) -> ())?
    
    var body: some View {
        
        VStack(content: {
            VStack {
                HStack(alignment: .top, content: {
                    let player1 = players.first(where: {
                        $0.positionAttack == .linksAusen
                    })
                    
                    PlayerNumberItem(player: player1, position: .linksAusen, action: {
                        if let player1 {
                            actionForPlayer(player1)
                        } else {
                            actionForPosition?(.linksAusen)
                        }
                    }).padding(.horizontal)
                    
                    Spacer()
                    
                    let player2 = players.first(where: {
                        $0.positionAttack == .rechtsAusen
                    })
                    
                    PlayerNumberItem(player: player2, position: .rechtsAusen, action: {
                        if let player2 {
                            actionForPlayer(player2)
                        } else {
                            actionForPosition?(.rechtsAusen)
                        }
                    }).padding(.horizontal)
                })
                
                let player3 = players.first(where: {
                    $0.positionAttack == .kreisläufer
                })
                
                PlayerNumberItem(player: player3, position: .kreisläufer, action: {
                    if let player3 {
                        actionForPlayer(player3)
                    } else {
                        actionForPosition?(.kreisläufer)
                    }
                })
            }
            .background(
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let cornerRadius = 160
                        let rectWidth = width - height
                        
                        let centerX = width / 2 - rectWidth / 2
                        let centerY = -height / 4 - height
                        
                        path.addRoundedRect(in: CGRect(origin: CGPoint(x: centerX, y: centerY), size: CGSize(width: rectWidth, height: height*2)), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
                    }
                    .fill(Color.accentColor)
                    .clipShape(Rectangle().offset(y: -5))
                }
            )

            HStack(alignment: .top, spacing: Padding.large(), content: {
                let player4 = players.first(where: {
                    $0.positionAttack == .rückraumLinks
                })
                
                PlayerNumberItem(player: player4, position: .rückraumLinks, action: {
                    if let player4 {
                        actionForPlayer(player4)
                    } else {
                        actionForPosition?(.rückraumLinks)
                    }
                })
                
                let player5 = players.first(where: {
                    $0.positionAttack == .rückraumMitte
                })
                
                PlayerNumberItem(player: player5, position: .rückraumMitte, action: {
                    if let player5 {
                        actionForPlayer(player5)
                    } else {
                        actionForPosition?(.rückraumMitte)
                    }
                })
                .padding()
                
                let player6 = players.first(where: {
                    $0.positionAttack == .rückraumRechts
                })
                
                PlayerNumberItem(player: player6, position: .rückraumRechts, action: {
                    if let player6 {
                        actionForPlayer(player6)
                    } else {
                        actionForPosition?(.rückraumRechts)
                    }
                })
            })
            .padding()
        })
        .background(
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let cornerRadius = 160
                    let centerY = -height / 4 - height - 28 - 14
                    path.addRoundedRect(in: CGRect(origin: CGPoint(x: 0, y: centerY), size: CGSize(width: width, height: height*2)), cornerSize: CGSize(width: cornerRadius, height:cornerRadius))
                }
                .stroke(style: StrokeStyle(lineWidth: 3, dash: [10]))
                .clipShape(Rectangle().offset(y: -5))
            }
        )

        
        HStack(content: {
            Spacer()
            
            let player7 = players.first(where: {
                $0.positionAttack == .torhüter
            })
            
            PlayerNumberItem(player: player7, position: .torhüter, action: {
                if let player7 {
                    actionForPlayer(player7)
                } else {
                    actionForPosition?(.torhüter)
                }
            })
            .padding()
        })
        
        
        
        
    }
}
