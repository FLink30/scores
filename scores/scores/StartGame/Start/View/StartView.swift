//
//  StartView.swift
//  scores
//
//  Created by Franziska Link on 10.01.24.
//

import SwiftUI

struct StartView: View {
    
    @ObservedObject var viewModel: StartViewModel
    @State var selectedPlay: Play?
    
    var body: some View {
        ScrollView {
            if viewModel.isFetchingData {
                ProgressView("Loading...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
            } else {
                VStack(alignment: .leading) {
                    if let profile = viewModel.profile {
                        Text("Hallo \(profile.firstName) \(profile.lastName)!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, Padding.large())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("Nächstes Spiel")
                        .font(.title)
                        .padding(.top, Padding.large())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let nextGame = viewModel.getNextGame() {
                        NavigationLink {
                            CheckGameView(viewModel: CheckGameViewModel(game: nextGame, team: viewModel.team))
                        } label: {
                            GameListItemView(game: nextGame,
                                             lastGame: false)
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    
                    
                    Text("Spielzüge-Playbook")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, Padding.large())
                    HStack() {
                        NavigationLink {
                            AddPlayView(action: { play in
                                viewModel.addPlay(play: play)
                            })
                            .frame(maxHeight: .infinity, alignment: .top)
                            .navigationBarTitleDisplayMode(.large)
                        } label: {
                            PlayListItemHelperView(type: .add)
                        }
                        
                        PlayListView(playList: viewModel.playList, selectedPlay: $selectedPlay, isDisabled: true)
                    }
                    .padding()
                }
                Spacer()
            }
            
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}
