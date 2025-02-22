import Foundation
import Combine

class StartGameViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var counter = 0
    @Published var gameStarted = false
    @Published var currentSelectedPlayer: Players?
    @Published var game: Games
    @Published var playList: [Play]
    
    @Published var goalsHome: Int = 0
    @Published var goalsOpponent: Int = 0
    
    @Published var isTimerRunning: Bool = false
    @Published var isActionListViewVisible = false
    @Published var presentOverlay = false
    @Published var isShowingNewView = false
    @Published var showAlert = false
    
    @Published var goalThrow: (Int, Play, Bool)?
    
    var actions: [ActionType] = []
    
    var passivePlayerList: [Players] {
        var list: [Players] = []
        for player in game.players {
            if !game.activeHomeTeamPlayerList.contains(player) {
                list.append(player)
            }
        }
        return list
    }
    
    @Published var selectedExchangePlayer: Players?
    var team: Teams
    
    init(game: Games, team: Teams) {
        self.game = game
        self.team = team
        self.playList = game.playbook
    }
    
    func addGameAction(for item: ActionType) async {
        let actionsProvider = CloudServiceManager.shared.actionsProvider
        do {
            let _ = try await actionsProvider.createAction(type: item)
        } catch {
            
        }
        DispatchQueue.main.async {
            switch item {
            case .goalThrow(let goalThrow):
                if let goalThrow, goalThrow.goal {
                    self.goalsHome += 1
                }
            case .exchange(let exchangePlayers):
                guard let exchangePlayers, let selectedPlayer = exchangePlayers.selectedPlayer else { return }
                guard exchangePlayers.exchangePlayer.positionAttack == selectedPlayer.positionAttack else { return }
                guard let index = self.game.activeHomeTeamPlayerList.firstIndex(where: { $0 == selectedPlayer }) else { return }
                self.game.activeHomeTeamPlayerList[index] = exchangePlayers.exchangePlayer
            default: break
            }
            self.dismissAll()
        }
        
    }
    
    func fetchData() {
        if isActionListViewVisible {
            isActionListViewVisible = false
        } else {
            Task {
                let result = await fetchData()
                if case .success(let actions) = result {
                    DispatchQueue.main.async {
                        self.actions = actions
                        self.isActionListViewVisible = true
                    }
                }
            }
        }
        
    }
    
    func fetchData() async -> Result<[ActionType], Error> {
        do {
            let actionsProvider = CloudServiceManager.shared.actionsProvider
            let actions = try await actionsProvider.getAllActionsSorted(gameID: self.game.id)
            return .success(actions)
        } catch let error {
            return .failure(error)
        }
    }
    
    func playersForPosition() -> [Players] {
        guard let selectedPosition = currentSelectedPlayer?.positionAttack else { return [] }
        
        return passivePlayerList.filter { $0.positionAttack == selectedPosition }
    }
    
    func toggleTimer() {
        isTimerRunning.toggle()
    }
    
    func stopTimer() async {
        let gamesProvider = CloudServiceManager.shared.gamesProvider
        var newGame = self.game
        
        newGame.homePoints = self.goalsHome
        newGame.opponentPoints = self.goalsOpponent
        do {
            try await gamesProvider.updateGame(newGame)
            DispatchQueue.main.async {
                self.isTimerRunning = false
                self.isShowingNewView = true
            }
        } catch {
            
        }
    }
    
    func dismissAll() {
        presentOverlay = false
        isActionListViewVisible = false
        currentSelectedPlayer = nil
    }
}
