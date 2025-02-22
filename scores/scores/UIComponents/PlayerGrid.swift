//
//  PlayerGrid.swift
//  scores
//
//  Created by Franziska Link on 23.12.23.
//

import SwiftUI

struct PlayerGrid: View {
    var teamID: UUID
    var data: [Players?] = [nil]
    var action: (Players) -> ()
    @State var shouldShowSheet: Bool = false
    
    init(teamID: UUID, data: [Players], action: @escaping (Players) -> Void) {
        self.teamID = teamID
        self.data.append(contentsOf: data)
        self.action = action
        self.shouldShowSheet = shouldShowSheet
    }
    
    
    
    let columns = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Padding.medium()) {
                ForEach(data, id: \.self) { player in
                    PlayerGridItem(player: player) {
                        shouldShowSheet = true
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .padding(Padding.small())
        }
        .sheet(isPresented: $shouldShowSheet, content: {
            CreatePlayerView(createPlayerViewModel: CreatePlayerViewModel(teamID: teamID), doneButtonAction: { player in
                shouldShowSheet = false
                action(player)
            })
        })
        .background(.background)
    }
}


//#Preview {
//    return PlayerGrid(data: Player.createHomeTeamPlayerList())
//}
