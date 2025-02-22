//
//  TeamRegistrationView.swift
//  scores
//
//  Created by Franziska Link on 09.12.23.
//

import SwiftUI

struct TeamRegistrationView: View {
    @State
    var team: String = ""
    @State 
     var selectedSex: Sex = .female
    @State 
    private var selectedSexValue: String = ""
    @State
    var sexName: String = ""
    @State
    var association: String = ""
    @State
    var league: String = ""
    
    
    @State
    var errorMessage = ""
    var background = Color.gray
    
    
    @State var showingSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: Padding.prettySmall()){
                        Image(systemName: "shield")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Padding.icon(),
                                   height: Padding.icon())
                            .padding(Padding.medium())
                        
                        CustomButton(type: .plain, title: "Bearbeiten", action: editFoto)
                    }
                    
                    VStack(spacing: Padding.prettySmall()){
//                        InputField(
//                            text: $team, placeholder: "Name der Mannschaft", type: .default, errorMessage: errorMessage, onCommit: {
//                                errorMessage = "ERROR"
//                            })
//                        
//                        InputField(text: $selectedSexValue, placeholder: "Geschlecht", type: .default, errorMessage: errorMessage, onCommit: {
//                            errorMessage = "ERROR"
//                        }).onTapGesture {
//                            showingSheet = true
//                        }
//                        
//                        InputField(text: $association, placeholder: "Verband", type: .default, errorMessage: errorMessage, onCommit: {
//                            errorMessage = "ERROR"
//                        })
//                        InputField(text: $league, placeholder: "Liga", type: .default, errorMessage: errorMessage, onCommit: {
//                            errorMessage = "ERROR"
//                        })
                        // sheet soll von unten nach oben sliden
                    }
                    CustomButton(type: .filled, title: "Anlegen", action: saveTeam)
                }.sheet(isPresented: $showingSheet){
                    PickerSheetView <Sex>(selectedItem: $selectedSex)
                        .presentationDetents([.height(150)])
                }
                .navigationTitle("Mannschaft anlegen")
            }
            
        }
    }
            
            func editFoto() -> Void {}
            func saveTeam() -> Void {}
        
    }
    
    #Preview {
        TeamRegistrationView()
    }
