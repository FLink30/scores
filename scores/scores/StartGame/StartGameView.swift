import SwiftUI

struct StartGameView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var buttonImage: Image {
        if self.viewModel.isTimerRunning {
            return SystemImage.pauseFilled()
        } else {
            return SystemImage.playFilled()
        }
    }
    
    var navigationButtonImage: Image {
        if viewModel.isActionListViewVisible {
            return SystemImage.chevronRight()
        } else {
            return SystemImage.chevronLeft()
        }
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                VStack {
                    ResultView(counter: $viewModel.counter,
                               goalsHome: $viewModel.goalsHome,
                               goalsOpponent: $viewModel.goalsOpponent,
                               homeTeamName: viewModel.game.homeTeam.teamName,
                               opponentTeamName: viewModel.game.opponentTeam.teamName)
                    .padding(.horizontal)
                    .padding(.top)
                    .disabled(!self.viewModel.isTimerRunning)
                    
                    Divider()
                    
                    FieldView(players: viewModel.game.activeHomeTeamPlayerList, 
                              actionForPlayer: { player in
                        viewModel.currentSelectedPlayer = player
                        viewModel.presentOverlay = true
                        
                    })
                    .disabled(!self.viewModel.isTimerRunning)
                    Spacer()
                    
                    Divider()
                    
                    VStack(alignment: .center, spacing: Padding.small()) {
                        Button(action: {
                            viewModel.gameStarted = true
                            self.viewModel.toggleTimer()
                        }, label: {
                            buttonImage
                                .font(.system(size: 40))
                        })
                        
                        CustomButton(type: .plain, title: "Spiel beenden", disabled: !(!self.viewModel.isTimerRunning && viewModel.gameStarted), isCancelButton: true, action: {
                            viewModel.showAlert = true
                        })
                    }
                    .padding(.top, Padding.small())
                }
                
                HStack{
                    Spacer()
                    Button {
                        viewModel.fetchData()
                    } label: {
                        navigationButtonImage
                            .font(.system(size: 30))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal)
                    
                    if viewModel.isActionListViewVisible {
                        ActionListView(actions: viewModel.actions)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(.background.secondary)
                    }
                }
                .frame(alignment: viewModel.isActionListViewVisible ? .leading : .trailing)
            }
            .background(.background)
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .onTapGesture {
                viewModel.dismissAll()
            }
            .onReceive(timer) { _ in
                if self.viewModel.isTimerRunning {
                    viewModel.counter += 1
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowingNewView) {
                MenuView(viewModel: StartViewModel(team: viewModel.team))
            }
            .sheet(isPresented: $viewModel.presentOverlay, onDismiss: {
                viewModel.dismissAll()
            }, content: {
                if let selectedPlayer = viewModel.currentSelectedPlayer {
                    AddActionView(
                        gameID: viewModel.game.id,
                        time: viewModel.counter,
                        selectedPlayer: selectedPlayer,
                        playList: viewModel.playList,
                        activePlayer: viewModel.game.activeHomeTeamPlayerList,
                        playerList: viewModel.playersForPosition(),
                        action: { item in
                            if let item {
                                Task {
                                    await viewModel.addGameAction(for: item)
                                }
                            } else {
                                viewModel.dismissAll()
                            }
                    })
                }
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Spiel beenden"),
                      message: Text("Bist du dir sicher, dass du dieses Spiel beenden möchtest?"),
                      primaryButton: .destructive(Text("Beenden")) {
                    Task {
                        await self.viewModel.stopTimer()
                    }
                },
                      secondaryButton: .cancel(Text("Abbrechen")) {
                    viewModel.showAlert = false
                })
            }
            .frame(maxWidth: nil, maxHeight: nil)
        }
    } 
}
