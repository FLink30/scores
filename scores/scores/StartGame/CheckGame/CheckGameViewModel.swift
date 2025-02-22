import Foundation
import Combine

class CheckGameViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var gameCorrect: Bool = false
    @Published var selectedPlayer: Players?
    @Published var selectedPosition: PositionAttack?
    @Published var activePlayer: [Players] = []
    @Published var presentOverlay: Bool = false
    
    @Published var game: Games
    var passivePlayerList: [Players] {
        var list: [Players] = []
        for player in game.players {
            if !game.activeHomeTeamPlayerList.contains(player) {
                list.append(player)
            }
        }
        
        return list
    }
    
    @Published var isFetchingData: Bool = false
    @Published var isShowingNewView: Bool = false
    var team: Teams
    
    init(game: Games, team: Teams) {
        self.game = game
        self.team = team
        setupObservation()
    }
    
    func playerSelected(_ player: Players) {
        if !self.activePlayer.contains(player) {
            self.activePlayer.removeAll(where: { $0.positionAttack == player.positionAttack })
            self.activePlayer.append(player)
        }
        
        self.game.activeHomeTeamPlayerList = self.activePlayer
        
        self.presentOverlay = false
        self.selectedPlayer = nil
        self.selectedPosition = nil
    }
    
    func playersForPosition() -> [Players] {
        guard let selectedPosition else { return [] }
            
        return game.players.filter { $0.positionAttack == selectedPosition }
    }
    
    func addPlayer(_ player: Players) {
        game.players.append(player)
    }
    
    func startGame() {
        self.isFetchingData = true
        let actionsProvider = CloudServiceManager.shared.actionsProvider
        let gamesProvider = CloudServiceManager.shared.gamesProvider
        self.game.homePoints = 0
        self.game.opponentPoints = 0
        Task {
            do {
                for player in self.activePlayer {
                    let _ = try await actionsProvider.createAction(type: .exchange(ExchangePlayers(gameID: self.game.id, time: 0, exchangePlayer: player)))
                }
                try await gamesProvider.updateGame(self.game)
                
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    self.isShowingNewView = true
                }
            } catch {
                
            }
        }
    }
    
    private func setupObservation() {
        $activePlayer
            .receive(on: DispatchQueue.main)
            .map { players in
                if players.count == 7 {
                    for position in PositionAttack.allCases {
                        if players.first(where: { $0.positionAttack == position }) == nil {
                            return false
                        }
                    }
                    return true
                } else {
                    return false
                }
            }
            .assign(to: &$gameCorrect)
    }
}
