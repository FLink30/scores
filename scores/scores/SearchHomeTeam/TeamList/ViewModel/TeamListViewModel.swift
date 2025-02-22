//
//  SearchTeamView.swift
//  scores
//
//  Created by Franziska Link on 21.12.23.
//

import Foundation
import SwiftUI
import Combine

class TeamListViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()

    @Published var teamList: [Teams] = []
    @Published var team: Teams = Teams()
   
    // error
    @Published var errorMessage: String? = ""
    
    init(teamList: [Teams]) {
        self.teamList = teamList
        setupObservation()
    }
    
    // Set up Publisher-Subscriber-relationships
    // Realtionships enables to observe published properties and to react
    private func setupObservation() {
    }
    
}

