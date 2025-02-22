//
//  StartViewModel.swift
//  scores
//
//  Created by Franziska Link on 10.01.24.
//

import Foundation
import Combine

class StartViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var team: Teams
    var playList: [Play] = []
    var profile: Profile?
    @Published var isFetchingData: Bool = false
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    
    init(team: Teams?) {
        if let team {
            self.team = team
            fetchData()
        } else {
            isFetchingData = true
            self.team = Teams()
            Task {
                let result = await pullData()
                switch result {
                case .success(let team):
                    DispatchQueue.main.async {
                        self.team = team
                        self.isFetchingData = false
                        self.showAlert = false
                        self.errorMessage = ""
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.asString
                        self.isFetchingData = false
                    }
                    
                }
                DispatchQueue.main.async {
                    self.isFetchingData = false
                }
            }
            
        }
        
    }
    
    func fetchData() {
        isFetchingData = true
        Task {
            let result = await pullData()
            switch result {
            case .success(let team):
                DispatchQueue.main.async {
                    self.team = team
                    self.isFetchingData = false
                    self.showAlert = false
                    self.errorMessage = ""
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.asString
                    self.isFetchingData = false
                }
                
            }
            DispatchQueue.main.async {
                self.isFetchingData = false
            }
        }
    }
    
    func addPlay(play: Play) {
        isFetchingData = true
        Task {
            let result = await addPlay(play: play)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.fetchData()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.asString
                }
            }
            DispatchQueue.main.async {
                self.isFetchingData = false
            }
            
        }
    }
    
    func addPlay(play: Play) async -> Result<Void, ViewModelError> {
        var newPlay = play
        newPlay.teamID = team.id
        let playbookProvider = CloudServiceManager.shared.playbookProvider
        do {
            let _ = try await playbookProvider.createPlaybook(play: newPlay)
            return .success(())
        } catch let error as ViewModelError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(error))
        }
        
    }
    
    func pullData() async -> Result<Teams, ViewModelError> {
        do {
            let profile = try await fetchProfile()
            var team = try await fetchTeam(adminID: profile.userID)
            let players = try await retrievePlayers(team: team)
            let plays = try await retrievePlays(team: team)
            let games = try await retrieveGames(team: team, players: players, plays: plays)
            
            team.playList = plays
            team.players = players
            team.games = games
            team.playList = plays
            self.playList = plays
            self.profile = profile
            return .success(team)
        } catch let error as ViewModelError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(error))
        }
    }
    
    private func fetchProfile() async throws -> Profile {
        do {
            let profileProvider = CloudServiceManager.shared.profileProvider
            return try await profileProvider.getProfile()
        } catch let error as ProfileServiceError {
            throw ViewModelError.profileServiceError(error)
        }
    }
    
    private func fetchTeam(adminID: UUID) async throws -> Teams {
        do {
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            return try await teamsProvider.getTeamByID(adminID: adminID)
        } catch let error as TeamsRequestError {
            throw ViewModelError.teamsRequestError(error)
        }
    }
    
    private func retrievePlayers(team: Teams) async throws -> [Players] {
        do {
            var players: [Players] = []
            let playersProvider = CloudServiceManager.shared.playersProvider
            for id in team.playersID {
                let player = try await playersProvider.getPlayer(playerID: id)
                players.append(player)
            }
            return players
        } catch let error as PlayersServiceError{
            throw ViewModelError.playersServiceError(error)
        }
    }
    
    private func retrieveGames(team: Teams, players: [Players], plays: [Play]) async throws -> [Games] {
        do {
            var games: [Games] = []
            let gamesProvider = CloudServiceManager.shared.gamesProvider
            for id in team.gamesID {
                var game = try await gamesProvider.getGameByID(gamesID: id)
                game.players = players
                game.playbook = plays
                games.append(game)
            }
            
            return games
        } catch let error as GamesRequestError {
            throw ViewModelError.gamesRequestError(error)
        }
    }
    
    private func retrievePlays(team: Teams) async throws -> [Play] {
        do {
            let playbookProvider = CloudServiceManager.shared.playbookProvider
            return try await playbookProvider.getPlaybooks(teamID: team.id)
        } catch  {
            return []
        }
    }
    
    func getNextGame() -> Games? {
        let futureGames = team.games.filter { $0.gameStart.timeIntervalSinceNow > 0 }
        let sortedGames = futureGames.sorted { $0.gameStart < $1.gameStart }
        return sortedGames.first
    }
}

protocol CustomError: Error {
    var asString: String { get }
}
