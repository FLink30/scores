import Foundation
import SwiftUI

struct GoalThrowActionView: View {
    
    @State var selectedGoalItem: Int?
    @State var selectedPlayItem: Play?
    @State var isSuccessful: Bool?
    @State var playerList: [Players]?
    
    var playList: [Play]
    
    var isAllSelected: Bool {
        if selectedGoalItem != nil &&
            selectedPlayItem != nil &&
            isSuccessful != nil {
            return true
        } else {
            return false
        }
    }
    
    var action: (Int, Play, Bool) -> ()

    var body: some View {
        VStack(spacing: Padding.large()) {
            Text("Torwurf anlegen")
                .font(.title2)
            GoalGridView(selectedItem: $selectedGoalItem)
            
            Text("Spielzug")
                .font(.title2)
            
            PlayListView(playList: playList, selectedPlay: $selectedPlayItem)
            
            Text("Erfolgreich?")
                .font(.title2)
            
            SuccessfulView(successful: $isSuccessful)
        }
        .padding()
        .onChange(of: isAllSelected) { oldValue, newValue in
            if newValue {
                if let selectedGoalItem, let selectedPlayItem, let isSuccessful {
                    action(selectedGoalItem, selectedPlayItem, isSuccessful)
                }
            }
        }
    }
}
