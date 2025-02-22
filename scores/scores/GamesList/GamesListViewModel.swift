import Foundation
import Combine
import os

class GamesListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    let logger = Logger(subsystem: "com.hdmstuttgart.scores", category: "GamesList")
    @Published var createGameViewModel: CreateGameViewModel
    @Published var team: Teams
    
    @Published var nextGamesList: [Games] = []
    @Published var lastGamesList: [Games] = []
    
    @Published private var games: [Games]?
    
    @Published var isFetchingData: Bool = false
    
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    init(team: Teams) {
        self.team = team
        self.games = team.games
        self.createGameViewModel = CreateGameViewModel(team: team)
        setupObservation()
        fetchData()
    }
    
    private func setupObservation() {
        $games
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .sink { games in
                self.filterTeamGamesList(games: games)
            }
            .store(in: &cancellables)
    }
    
    /// filters the list of games of the team and assigns it to the corresponding list
    func filterTeamGamesList(games: [Games]) -> Void {
        lastGamesList = []
        nextGamesList = []
        for game in games {
            if (game.homePoints != nil && game.opponentPoints != nil) {
                lastGamesList.append(game)
            } else {
                nextGamesList.append(game)
            }
        }
    }
    
    func fetchData() {
        isFetchingData = true
        Task {
            let result = await fetchData()
            switch result {
            case .success(let team):
                DispatchQueue.main.async {
                    self.team = team
                    self.games = team.games
                    self.isFetchingData = false
                    self.showAlert = false
                    self.errorMessage = ""
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
    
    func fetchData() async -> Result<Teams, ViewModelError> {
        do {
            var team = try await fetchTeam()
            let players = try await retrievePlayers(team: team)
            let plays = try await retrievePlays(team: team)
            let games = try await retrieveGames(team: team, players: players, plays: plays)
            team.players = players
            team.games = games
            team.playList = plays
            return .success(team)
        } catch let error as ViewModelError {
            return .failure(error)
        } catch {
            return .failure(.unexpected(error))
        }
    }
    
    private func fetchTeam() async throws -> Teams {
        do {
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            return try await teamsProvider.getTeamByID(id: team.id)
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
        } catch {
            return []
        }
    }
}

enum ViewModelError: Error {
    case unexpected(Error?)
    case teamsRequestError(TeamsRequestError)
    case playersServiceError(PlayersServiceError)
    case gamesRequestError(GamesRequestError)
    case playbookServiceError(PlaybookServiceError)
    case profileServiceError(ProfileServiceError)
    
    var asString: String {
        switch self {
        case .unexpected(let error):
            return "Ein unerwarteter Fehler ist aufgetreten: \(String(describing: error))."
        case .teamsRequestError(let teamsRequestError):
            return teamsRequestError.asString
        case .playersServiceError(let playersServiceError):
            return playersServiceError.asString
        case .gamesRequestError(let gamesRequestError):
            return gamesRequestError.asString
        case .playbookServiceError(let playbookServiceError):
            return playbookServiceError.asString
        case .profileServiceError(let profileServiceError):
            return profileServiceError.asString
        }
    }
}
