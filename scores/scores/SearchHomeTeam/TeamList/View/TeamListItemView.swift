//
//  TeamListItemView.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import SwiftUI

struct TeamListItemView: View {
    
    @ObservedObject var searchTeamViewModel: SearchTeamViewModel
    var team: Teams
    // if team already has an admin, user should not be able to select the team
    var isDisabled: Bool {
        return team.adminID != nil
    }
    var teamName: String {
        if (isDisabled){
            return "\(team.teamName) *"
        }
        return team.teamName
    }
    var textColor: Color {
        return isDisabled ? Color.secondary : Color.primary 
    }
    @State var teamIsSelected: Bool
    
    init(searchTeamViewModel: SearchTeamViewModel, team: Teams) {
        self.searchTeamViewModel = searchTeamViewModel
        self.team = team
        _teamIsSelected = State(initialValue: (searchTeamViewModel.foundedTeams.first != nil))
    }
    var body: some View {
        HStack {
            // Toggle Checkbox ///////////////////////////////////////
            // if selected team is current team -> checkmark
            if !isDisabled {
                Image(systemName: searchTeamViewModel.team == team ? "checkmark.circle" : "circle")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if (searchTeamViewModel.team == team){
                            searchTeamViewModel.team = Teams()
                        }else {
                            searchTeamViewModel.team = team
                        }
                    }
            }
            // Name for team
            Text(teamName)
                .foregroundColor(textColor)
                .disabled(isDisabled)
        }
    }
}
