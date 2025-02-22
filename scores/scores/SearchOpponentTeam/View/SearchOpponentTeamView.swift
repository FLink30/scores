//
//  TeamListView.swift
//  scores
//
//  Created by Franziska Link on 19.01.2023.
//

import SwiftUI
struct SearchOpponentTeamView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showingSheet: Bool = false
    var opponentTeamList: [Teams]
    @Binding var selectedOpponent: Teams?
    @Binding var hometeam: Teams
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: Padding.large()) {
                    Text("Wähle einen Gegner")
                        .font(.headline)
                    NavigationLink(destination:
                                    CreateTeamView(searchTeamViewModel:
                                                    SearchTeamViewModel(adminID: nil,
                                                                        sex: hometeam.sex,
                                                                        association: hometeam.association,
                                                                        league: hometeam.league,
                                                                        season: hometeam.season),
                                                   createOpponentTeam: true,
                                                   selectedOpponent: $selectedOpponent),
                                   label: {
                        CustomButton(type: .icon, disabled: false, image: "plus")
                    })
                }
                // List contains Teams
                if(!opponentTeamList.isEmpty) {
                    List(opponentTeamList) { team in
                        HStack {
                            SearchTeamItemView(team: team, selectedOpponent: $selectedOpponent)
                        }
                    }
                }else {
                    // List does not contain Teams
                    List {
                        Text("Keine Ergebnisse")
                            .padding(Padding.medium())
                            .foregroundColor(.gray)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    CustomButton(type: .plain, title: "Abbrechen", disabled: false, action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    CustomButton(type: .plain,
                                 title: "Fertig",
                                 disabled: selectedOpponent == nil,
                                 action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
        }
    }
}
