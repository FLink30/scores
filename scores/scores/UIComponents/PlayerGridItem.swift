//
//  GridItem.swift
//  scores
//
//  Created by Franziska Link on 23.12.23.
//

import SwiftUI

struct PlayerGridItem: View {
    var player: Players?
    var action: () -> ()
    
    var body: some View {
        if let player {
            VStack(content: {
                ZStack {
                    Circle()
                        .fill(.background.secondary)
                    
                    SystemImage.person()
                        .font(.system(size: 40))
                        .foregroundStyle(.primary)
                        .padding()
                }
                .frame(maxWidth: 100, maxHeight: 100)
                
                Text("\(player.firstName) \(player.lastName)")
            })
        } else {
            Button(action: {
                action()
            }, label: {
                VStack(content: {
                    ZStack {
                        Circle()
                            .fill(.background.secondary)
                        
                        SystemImage.plus()
                            .font(.system(size: 40))
                            .foregroundStyle(Color.accentColor)
                            .padding()
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                })
            })
        }
        
    }
}
//
//#Preview {
//    PlayerGridItem(player: Player.createHomePlayer(), action: {
//        
//    })
//}
