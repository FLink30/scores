//
//  SearchTeamItemView.swift
//  scores
//
//  Created by Franziska Link on 18.01.24.
//

import SwiftUI

struct SearchTeamItemView: View {
    var team: Teams
    @Binding var selectedOpponent: Teams?
 
    var body: some View {
        HStack {
            // Toggle Checkbox ///////////////////////////////////////
            // if selected team is current team -> checkmark
            Image(systemName: selectedOpponent == team ? "checkmark.circle" : "circle")
                .foregroundColor(.blue)
                .onTapGesture {
                    if (selectedOpponent == team){
                        selectedOpponent = Teams()
                    }else {
                        selectedOpponent = team
                    }
                }
            // Coat of Arms Icon ///////////////////////////////////////
            Image("CoatOfArms")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(maxWidth: Padding.iconPrettySmall())
            // Team name ///////////////////////////////////////
            Text(team.teamName)
                .padding(Padding.medium())
        }
    }
}
