import SwiftUI

struct CheckGameView: View {
    @ObservedObject var viewModel: CheckGameViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isFetchingData {
                    ProgressView("Loading...")
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .padding()
                } else {
                    VStack(spacing: Padding.large()) {
                        FieldView(players: viewModel.activePlayer, actionForPlayer: { player in
                            viewModel.selectedPlayer = player
                            viewModel.selectedPosition = player.positionAttack
                            viewModel.presentOverlay = true
                        }, actionForPosition: { position in
                            viewModel.selectedPosition = position
                            viewModel.presentOverlay = true
                        })
                        
                        Spacer()
                        
                        CustomButton(type: .filled, title: "Spiel starten", disabled: !viewModel.gameCorrect, action: {
                            self.viewModel.startGame()
                        })
                        
                    }
                    .padding(.vertical)
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowingNewView) {
                StartGameView(viewModel: StartGameViewModel(game: viewModel.game, team: viewModel.team))
            }
            .overlay(
                Group {
                    if viewModel.presentOverlay {
                        if !viewModel.playersForPosition().isEmpty {
                            ExchangeActionView(playerList: viewModel.playersForPosition(), action: { player in
                                if let player {
                                    viewModel.playerSelected(player)
                                }
                                
                            })
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background.secondary)
                                    .shadow(radius: 13)
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        } else {
                            VStack {
                                Text("Es wurde noch kein Spieler für diese Position erstellt.")
                                    .font(.title2)
                                    .frame(alignment: .leading)
                                
                                NavigationLink {
                                    CreatePlayerView(createPlayerViewModel: CreatePlayerViewModel(teamID: UUID(uuidString: viewModel.game.homeTeam.teamID)!), doneButtonAction: { player in
                                        viewModel.addPlayer(player)
                                    })
                                } label: {
                                    CustomButton(type: .bordered,
                                                 title: "Spieler erstellen",
                                                 disabled: false)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background.secondary)
                                    .shadow(radius: 13)
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        }
                        
                    }
                }
            )
            
            .onTapGesture {
                viewModel.selectedPlayer = nil
                viewModel.selectedPosition = nil
                viewModel.presentOverlay = false
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
                    NavigationLink {
                        CreatePlayerView(createPlayerViewModel: CreatePlayerViewModel(teamID: UUID(uuidString: viewModel.game.homeTeam.teamID)!), doneButtonAction: { player in
                            viewModel.addPlayer(player)
                        })
                    } label: {
                        CustomButton(type: .icon,
                                     disabled: false,
                                     image: "plus")
                    }
                }
            }
        }
    }
}
