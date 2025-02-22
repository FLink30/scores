//
//  CreatePlayerViewModel.swift
//  scores
//
//  Created by Franziska Link on 22.12.23.
//

import Foundation
import SwiftUI
import Combine
import os

class CreateTeamViewModel: ObservableObject {
    let logger = Logger(subsystem: "com.hdmstuttgart.scores", category: "GamesList")
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var team: Teams
    @Published var selectedName: String = ""

    @Published var teamIsCompleted = false

    @Published var errorMessage: String? = ""
 
    
    init(team: Teams){
        self.team = team
        setUpObservation()
    }
    
    func setUpObservation () {
        $selectedName
            .removeDuplicates()
            .compactMap { $0 }
            .sink { selectedName in
                self.team.teamName = selectedName
                self.logger.log("team has name: \(self.team.teamName)")
                self.logger.log("team is completed: \(self.teamIsCompleted)")
            }
            .store(in: &cancellables)
    }
    
    func resetTeam() {
        selectedName = ""
    }
}
