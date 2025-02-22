import Foundation
import SwiftUI

struct ActionListView: View {
    var actions: [ActionType]
    
    var sortedActions: [ActionType] {
        return actions.sorted(by: { $0.time < $1.time })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Padding.medium()) {
                
                ForEach(actions.sorted(by: { $0.time < $1.time }), id: \.self) { action in
                    VStack {
                        switch action {
                        case .exchange(let exchangeAction):
                            if let exchangeAction {
                                ExchangeItemView(item: exchangeAction, type: action)
                            } else {
                                Text("Test")
                            }
                        case .goalThrow(let goalThrowAction):
                            if let goalThrowAction {
                                GoalThrowItemView(item: goalThrowAction, type: action)
                            } else {
                                Text("Test")
                            }
                        case .punishment(let punishmentAction):
                            if let punishmentAction {
                                PunishmentItemView(item: punishmentAction)
                            } else {
                                Text("Test")
                            }
                        case .trf(let trfAction):
                            if let trfAction{
                                TRFItemView(item: trfAction)
                            } else {
                                Text("Test")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerSize: CGSize(width: 4, height: 4),
                                                 style: .continuous).fill().foregroundStyle(.background.secondary))
                    
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        
    }
}

//#Preview {
//    return ActionListView(actions: [.exchange(nil), .goalThrow(nil)])
//}

struct ExchangeItemView: View {
    var item: ExchangePlayers
    var type: ActionType
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: Padding.medium(), content: {
                type.asImage
                    .frame(width: 16)
                    .font(.title2)
                Text("\(Int(item.time).formattedTime): ")
                
            })
            
            HStack(spacing: Padding.medium()) {
                if let selectedPlayer = item.selectedPlayer {
                    Text("\(selectedPlayer.firstName) \(selectedPlayer.lastName)")
                    
                    type.asImage
                        .frame(width: 16)
                        .font(.body)
                    
                    Text("\(item.exchangePlayer.firstName) \(item.exchangePlayer.lastName)")
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct GoalThrowItemView: View {
    var item: GoalThrow
    var type: ActionType
    
    var color: Color {
        if item.goal {
            return .green
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading)  {
            HStack(spacing: Padding.medium(), content: {
                type.asImage
                    .frame(width: 16)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Text("\(Int(item.time).formattedTime): ")
                
                Text("\(item.scorer.firstName) \(item.scorer.lastName)")
                
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct PunishmentItemView: View {
    var item: Punishment
    
    var body: some View {
        VStack(alignment: .leading)  {
            HStack(spacing: Padding.medium(), content: {
                item.type.view
                
                Text("\(Int(item.time).formattedTime): ")
                
                Text("\(item.player.firstName) \(item.player.lastName)")
                
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct TRFItemView: View {
    var item: TRF
    
    var body: some View {
        VStack(alignment: .leading)  {
            HStack(spacing: Padding.medium(), content: {
                Text("TRF")
                    .foregroundStyle(.primary)
                
                Text("\(Int(item.time).formattedTime): ")
                
                Text("\(item.player.firstName) \(item.player.lastName)")
                
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}
