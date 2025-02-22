//
//  GamesListView.swift
//  scores
//
//  Created by Franziska Link on 05.01.24.
//

import SwiftUI

struct GamesListView: View {
    
    @State var showingSheet: Bool = false
    @ObservedObject var gamesListViewModel: GamesListViewModel
    @State private var singleSelection: UUID?
    
    var body: some View {
        
        ScrollView {
            if gamesListViewModel.isFetchingData {
                ProgressView("Loading...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
            } else{
                VStack(alignment: .leading) {
                    DisclosureGroup {
                        ForEach(gamesListViewModel.nextGamesList.sorted(by: { $0.gameStart < $1.gameStart }), id: \.self) { game in
                            
                            NavigationLink {
                                CheckGameView(viewModel: CheckGameViewModel(game: game, team: gamesListViewModel.team))
                            } label: {
                                GameListItemView(game: game,
                                                 lastGame: false)
                                .padding()
                            }
                            .buttonStyle(.plain)
                        }
                    } label: {
                        HStack {
                            Text("Eure nächsten Spiele")
                                .font(.title)
                        }
                    }
                    DisclosureGroup {
                        ForEach(gamesListViewModel.lastGamesList.sorted(by: { $0.gameStart < $1.gameStart })) { game in
                            GameListItemView(game: game,
                                             lastGame: true)
                            .padding()
                        }
                        
                    } label: {
                        HStack {
                            Text("Eure letzten Spiele")
                                .font(.title)
                        }
                    }
                }
                .padding()
                .navigationBarItems(trailing:
                                        Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: Padding.medium())
                })
                .sheet(isPresented: $showingSheet) {
                    CreateGameView(createGameViewModel: CreateGameViewModel(team: gamesListViewModel.team), 
                                   doneButtonAction: {
                        showingSheet = false
                        gamesListViewModel.fetchData()
                    })
                        .navigationBarTitleDisplayMode(.large)
                    
                }
            }
        }
        .alert(isPresented: $gamesListViewModel.showAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(gamesListViewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}
