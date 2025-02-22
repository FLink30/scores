import Foundation
import SwiftUI

struct AddActionView: View {
    
    var gameID: UUID
    var time: Int
    var selectedPlayer: Players
    var playList: [Play]
    var activePlayer: [Players]
    var playerList: [Players]
    var action: (ActionType?) -> ()
    
    @State var selectedItem: ActionType?
    @State var presentSheet: Bool = false

    var body: some View {
        NavigationView(content: {
            VStack(alignment: .leading, content: {
                NavigationLink {
                    GoalThrowActionView(playList: playList) { selectedGoalItem, selectedPlayItem, isSuccessful in
                        action(.goalThrow(GoalThrow(gameID: gameID, time: time, players: activePlayer, play: selectedPlayItem, goal: isSuccessful, scorer: selectedPlayer, throwingTarget: selectedGoalItem)))
                    }
                } label: {
                    AddActionItemView(item: .goalThrow(nil))
                }
                Divider()
                NavigationLink {
                    TRFActionView(playList: playList, action: { play in
                        action(.trf(TRF(gameID: gameID, time: time, player: selectedPlayer, play: play)))
                    })
                } label: {
                    AddActionItemView(item: .trf(nil))
                }
                Divider()
                NavigationLink {
                    PunishmentActionView { type in
                        action(.punishment(Punishment(gameID: gameID, time: time, type: type, player: selectedPlayer)))
                    }
                } label: {
                    AddActionItemView(item: .punishment(nil))
                }
                Divider()
                NavigationLink {
                    ExchangeActionView(playerList: playerList, action: { selectedExchangePlayer in
                        if let selectedExchangePlayer {
                            action(.exchange(ExchangePlayers(gameID: gameID, time: time, selectedPlayer: selectedPlayer, exchangePlayer: selectedExchangePlayer)))
                        } else {
                            action(nil)
                        }
                    })
                } label: {
                    AddActionItemView(item: .exchange(nil))
                }
            })
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        })
        
    }
}
