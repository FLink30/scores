//
//  GridItem.swift
//  scores
//
//  Created by Franziska Link on 23.12.23.
//

import SwiftUI

struct PlayerNumberItem: View {
    var player: Players?
    var position: PositionAttack
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            if let player {
                Circle()
                    .fill(.secondary)
                    .frame(width: Padding.iconPrettySmall())
                    .overlay(
                        Text("\(player.number)")
                            .font(.system(size: 32))
                    )
            } else {
                VStack(content: {
                    Circle()
                        .fill(.primary)
                        .frame(width: Padding.iconPrettySmall())
                    
//                    Text(position())
                })
            }
            
        })
        .buttonStyle(.plain)
    }
}
//
//#Preview {
//    PlayerNumberItem(player: Player.createHomePlayer(), position: .linksAusen, action: {
//        
//    })
//}
