//
//  CreateGameViewModel.swift
//  scores
//
//  Created by Franziska Link on 16.01.24.
//

import Foundation
import Combine
import os

class CreateGameViewModel: ObservableObject {
    let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var opponent: Teams?
    @Published var opponentTeamName: String = ""
    @Published var location: String = ""
    @Published var date: Date = Date()
    @Published var isHomeGame: Bool = false
    
    @Published var addHomeTeamPlayer = true
    @Published var errorMessage: String? = ""
    @Published var locationErrorMessage: String? = ""
    @Published var gameIsCompleted: Bool = false
    @Published var opponentTeamList: [Teams] = []
    
    @Published var team: Teams
    
    init(team: Teams) {
        self.team = team
        Task {
            await loadTeams()
        }
        setupObservation()
    }
    
    func setupObservation(){
        $opponent
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .compactMap({ $0 })
            .sink { opponent in
                self.opponentTeamName = opponent.teamName
            }
            .store(in: &cancellables)
        
        $opponent
            .combineLatest($location)
            .map { opponent, location  in
                opponent != nil && !location.isEmpty && self.locationErrorMessage == nil
            }
            .assign(to: &$gameIsCompleted)
        
        $location
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { location in
                if location.isEmpty {
                    self.locationErrorMessage = nil
                } else {
                    if location.isValidName {
                        self.locationErrorMessage = nil
                    } else {
                        self.locationErrorMessage = ErrorMessage.inputInvalid()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func addPlayer(addHomeTeamPlayer: Bool, player: Players) {
        DispatchQueue.main.async {
            if addHomeTeamPlayer {
                self.team.players.append(player)
            } else {
                self.opponent?.players.append(player)
            }
        }
    }
    
    func createGame() async -> Result<Void, ViewModelError> {
        guard let opponent else { fatalError() }

        let game = Games(homeGame: isHomeGame, 
                         gameStart: date,
                         location: location,
                         homePoints: nil,
                         opponentPoints: nil,
                         homeTeam: team.asTeamsGamesBackend,
                         opponentTeam: opponent.asTeamsGamesBackend)
        do {
            let gamesProvider = CloudServiceManager.shared.gamesProvider
            var game = try await gamesProvider.createGame(game: game)
            game.players = team.players
            return .success(())
        } catch let error as GamesRequestError {
            return .failure(ViewModelError.gamesRequestError(error))
        } catch {
            return .failure(ViewModelError.unexpected(error))
        }
    }
    
    func loadTeams() async {
        do {
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            let teamsList = try await teamsProvider.findTeams(association: team.association, league: team.league, series: team.season)
            DispatchQueue.main.async {
                self.opponentTeamList = teamsList.filter({ $0 != self.team })
            }
        } catch {
            opponentTeamList = []
        }
    }
}
