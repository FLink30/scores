//
//  TeamListItemViewModel.swift
//  scores
//
//  Created by Franziska Link on 19.12.23.
//

import Foundation
import SwiftUI
import Combine

class TeamListItemViewModel: ObservableObject {
    @Published var team: Teams
    
    init(team: Teams) {
        self.team = team
    }
    
    var isDisabled: Bool {
        return !(team.adminID == nil)
    }
    
    var teamName: String {
        if (isDisabled){
            return "\(team.teamName) *"
        }
        return team.teamName
    }
    
    var textColor: Color {
        return isDisabled ? Color.gray : Color.primary
    }
}
