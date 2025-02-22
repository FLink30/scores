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

class CreatePlayerViewModel: ObservableObject {
    let logger = Logger(subsystem: "com.hdmstuttgart.scores", category: "GamesList")
    
    private var cancellables = Set<AnyCancellable>()
    private var teamID: UUID
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var number: Int?
    @Published var positionAttack: PositionAttack?
    
    @Published var selectedNumber: String = ""
    @Published var selectedPositionAttack: String = ""
    @Published var selectedPositionDefense: String = ""
    
    @Published var playerIsCompleted = false
    
    @Published var player: Players

    @Published var firstNameErrorMessage: String? = ""
    @Published var lastNameErrorMessage: String? = ""
    @Published var numberErrorMessage: String? = ""
    @Published var errorMessage: String? = ""
    
    private var isInputValid: Bool {
        firstNameErrorMessage == nil
        && lastNameErrorMessage == nil
        && numberErrorMessage == nil
    }
    
    
    init(teamID: UUID){
        self.teamID = teamID
        self.player = Players(teamID: teamID)
        setUpObservation()
    }
    
    func setUpObservation () {
        $firstName
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { firstName in
                if firstName.isEmpty {
                    self.firstNameErrorMessage = nil
                } else {
                    if firstName.isValidName {
                        self.firstNameErrorMessage = nil
                        self.logger.log("player has firstname: \(self.player.firstName)")
                        self.logger.log("player is completed: \(self.playerIsCompleted)")
                    } else {
                        self.firstNameErrorMessage = ErrorMessage.firstName()
                    }
                }
                self.player.firstName = firstName
            }
            .store(in: &cancellables)
        
        $lastName
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { lastName in
                if lastName.isEmpty {
                    self.lastNameErrorMessage = nil
                } else {
                    if lastName.isValidName {
                        self.lastNameErrorMessage = nil
                        self.logger.log("player has lastname: \(self.player.lastName)")
                        self.logger.log("player is completed: \(self.playerIsCompleted)")
                    } else {
                        self.lastNameErrorMessage = ErrorMessage.lastName()
                    }
                }
                self.player.lastName = lastName
            }
            .store(in: &cancellables)
        
        $selectedNumber
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { selectedNumber in
                if selectedNumber.isEmpty {
                    self.numberErrorMessage = nil
                } else {
                    if selectedNumber.containsOnlyDigits {
                        self.numberErrorMessage = nil
                        self.logger.log("player has trikot number: \(self.player.number)")
                        self.logger.log("player is completed: \(self.playerIsCompleted)")
                    } else {
                        self.numberErrorMessage = ErrorMessage.inputInvalid()
                    }
                }
                self.player.number = Int(selectedNumber) ?? 0
                
            }
            .store(in: &cancellables)
    
        $positionAttack
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { positionAttack in
                guard let positionAttack else {
                    return
                }
                self.selectedPositionAttack = positionAttack()
                self.player.positionAttack = positionAttack
            }
            .store(in: &cancellables)
        
        $player
            .removeDuplicates()
            .map { player in
                if self.isInputValid {
                    return !player.firstName.isEmpty && !player.lastName.isEmpty && player.number != 0
                } else {
                    return false
                }
            }
            .assign(to: &$playerIsCompleted)
    }
    
    func resetPlayer() {
        firstName = ""
        lastName = ""
        number = nil
        positionAttack = nil
    }
    
    func addPlayer() async -> Result <Players, Error> {
        let playersProvider = CloudServiceManager.shared.playersProvider
        do {
            var createdPlayer = try await playersProvider.createPlayer(player: player)
            createdPlayer.teamID = self.teamID
            return .success(createdPlayer)
        } catch {
            return .failure(error)
        }
    }
    
    func dismissSheet(type: InputType?) {
        switch type {
        case .positionAttack:
            if self.positionAttack == nil {
                self.positionAttack = PositionAttack.allCases[0]
            }
        default:
            break
        }
    }
 
}
