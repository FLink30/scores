//
//  CreateGameVIew.swift
//  scores
//
//  Created by Franziska Link on 16.01.24.
//

import SwiftUI

struct CreateGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var createGameViewModel: CreateGameViewModel
    @State var showingPlayerSheet: Bool = false
    @State var showingOpponentSheet: Bool = false
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    var doneButtonAction: () -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: Padding.large()) {
                    VStack(spacing: Padding.prettySmall()) {
                        
                        // MARK: - Search for Opponent and input Location
                        InputField (text: $createGameViewModel.opponentTeamName,
                                    placeholder: "Gegner Mannschaft",
                                    errorMessage: $createGameViewModel.errorMessage,
                                    onCommit: {},
                                    fieldType: .teamName)
                        .onTapGesture {
                            showingOpponentSheet = true
                        }
                        
                        InputField (text: $createGameViewModel.location,
                                    placeholder: "Ort",
                                    errorMessage: $createGameViewModel.locationErrorMessage,
                                    onCommit: {},
                                    fieldType: .teamName)
                        
                        Toggle(isOn: $createGameViewModel.isHomeGame, label: {
                            Text("Heimspiel")
                        })
                        .padding(.horizontal)
                        
                        // MARK: - Date Picker
                        CustomDatePicker(date: $createGameViewModel.date)
                        Divider()
                    }
                    
                    // MARK: - Home Players
                    VStack  {
                        HStack(spacing: Padding.prettyLarge()) {
                            DisclosureGroup {
                                PlayerGrid(teamID: createGameViewModel.team.id ,
                                           data: createGameViewModel.team.players ,
                                           action: { player in
                                    createGameViewModel.addPlayer(addHomeTeamPlayer: true, player: player)
                                })
                                .padding()
                            } label: {
                                HStack {
                                    Text("Unsere Spieler")
                                }
                            }
                            .padding(.horizontal)
                        }
                        Divider()
                    }
                    
                    // MARK: - opponent Players
                    VStack(alignment: .leading, spacing: Padding.small()) {
                        if let opponent = createGameViewModel.opponent {
                            HStack(spacing: Padding.prettyLarge()) {
                                DisclosureGroup {
                                    PlayerGrid(teamID: opponent.id, data: opponent.players, action: { player in
                                        createGameViewModel.addPlayer(addHomeTeamPlayer: false, player: player)
                                    })
                                    .padding()
                                } label: {
                                    HStack {
                                        Text("Gegner Spieler")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // MARK: - start Game
                    CustomButton(type: .bordered,
                                 title: "Erstellen",
                                 disabled: !createGameViewModel.gameIsCompleted,
                                 action: {
                        Task {
                            let result = await createGameViewModel.createGame()
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    self.doneButtonAction()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            case .failure(let error):
                                self.errorMessage = error.asString
                                self.showAlert = true
                            }
                        }
                        
                    })
                }
            }
            .onChange(of: createGameViewModel.opponent, { oldValue, newValue in
                if newValue != nil {
                    showingOpponentSheet = false
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Spiel erstellen")
                .sheet(isPresented: $showingOpponentSheet, content: {
                    SearchOpponentTeamView(opponentTeamList: createGameViewModel.opponentTeamList,
                                           selectedOpponent: $createGameViewModel.opponent,
                                           hometeam: $createGameViewModel.team)
                })
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        CustomButton(type: .plain, title: "Abbrechen", disabled: false, action: {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        // MARK: - game has to be completed for creating
                        CustomButton(type: .plain, title: "Fertig",
                                     disabled: !createGameViewModel.gameIsCompleted,
                                     action: {
                            Task {
                                let _ = await createGameViewModel.createGame()
                            }
                            doneButtonAction()
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
        }
    }
}
//
//#Preview {
//    CreateGameView(createGameViewModel: CreateGameViewModel(team: Teams()), doneButtonAction: {})
//}
//
