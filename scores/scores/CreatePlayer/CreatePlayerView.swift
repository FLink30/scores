//
//  CreatePlayerView1.swift
//  scores
//
//  Created by Franziska Link on 22.12.23.
//

import SwiftUI

struct CreatePlayerView: View {
    
    @ObservedObject var createPlayerViewModel: CreatePlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var showingSheet = false
    @FocusState var focusedField: InputType?
    var doneButtonAction: (Players) -> ()
    
    @State var isCreatingPlayer: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                Text("Spieler erstellen")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(maxWidth: Padding.icon())
                    Text("Bearbeiten")
                        .foregroundColor(Color.gray)
                        .frame(alignment: .center)
                }.padding(Padding.medium())
                
                InputField(
                    text: $createPlayerViewModel.firstName,
                    placeholder: "Vorname",
                    type: .default,
                    errorMessage: $createPlayerViewModel.firstNameErrorMessage,
                    onCommit: {
                        self.focusedField = .lastName
                    }, isFocused: _focusedField,
                    fieldType: .firstName
                )
                .onTapGesture {
                    showingSheet = false
                }
                
                InputField(
                    text: $createPlayerViewModel.lastName,
                    placeholder: "Nachname",
                    type: .default,
                    errorMessage: $createPlayerViewModel.lastNameErrorMessage,
                    onCommit: {
                        self.focusedField = .number
                    }, isFocused: _focusedField,
                    fieldType: .lastName
                )
                .onTapGesture {
                    showingSheet = false
                }
                
                // hier sollte die Tastatur direkt auf Zahlen springen
                InputField(
                    text: $createPlayerViewModel.selectedNumber,
                    placeholder: "Trikotnummer",
                    type: .number,
                    errorMessage: $createPlayerViewModel.numberErrorMessage,
                    onCommit: {
                        self.focusedField = .positionAttack
                    }, isFocused: _focusedField,
                    fieldType: .number
                ) .onTapGesture {
                    showingSheet = false
                }
                
                InputField(
                    text: $createPlayerViewModel.selectedPositionAttack,
                    placeholder: "Position im Angriff",
                    type: .default,
                    errorMessage: $createPlayerViewModel.errorMessage,
                    onCommit: {}, isFocused: _focusedField,
                    fieldType: .positionAttack
                )
                .onTapGesture {
                    showingSheet = true
                }
                
                Spacer(minLength: Padding.large())
                CustomButton(type: .bordered, title: "Erstellen", disabled:   !createPlayerViewModel.playerIsCompleted,
                             action: {
                    Task {
                        // TODO: Alert
                        let result = await createPlayerViewModel.addPlayer()
                        switch result {
                        case .success(let player):
                            DispatchQueue.main.async {
                                doneButtonAction(player)
                            }
                            
                        case .failure:
                            break
                        }
                    }
                    
                })
                .disabled(isCreatingPlayer)
                Spacer(minLength: Padding.large())
                
            }
            .padding()
            .sheet(isPresented: $showingSheet, onDismiss: {
                createPlayerViewModel.dismissSheet(type: self.focusedField)
            }, content: {
                VStack(alignment: .trailing,
                       spacing: Padding.prettySmall()) {
                    CustomButton(type: .plain,
                                 title: "Fertig",
                                 disabled: false) {
                        showingSheet = false
                    }
                    switch focusedField {
                    case .positionAttack:
                        PickerSheetView <PositionAttack>(selectedItem: $createPlayerViewModel.positionAttack)
                            .presentationDetents([.fraction(0.3)])
                    default:
                        Text("Error")
                            .presentationDetents([.fraction(0.3)])
                    }
                }
            })
        }
    }
}
