import Foundation
import SwiftUI

struct ExchangeActionView: View {
    
    @State var selectedPlayer: Players?
    @State var playerList: [Players]
    var shouldShowNavigationBar: Bool = false
    var action: (Players?) -> ()
    @Environment(\.presentationMode) var presentationMode
    
    let columns = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    var body: some View {
        VStack {
            if playerList.isEmpty {
                Text("Kein Spieler zum Auswechseln verfügbar")
                    .font(.title2)
                    .frame(alignment: .leading)
                CustomButton(type: .plain, disabled: false, isCancelButton: true) {
                    action(nil)
                }
            } else {
                Text("Wähle einen Spieler zum Auswechseln")
                    .font(.title2)
                    .frame(alignment: .leading)
                LazyVGrid(columns: columns, spacing: Padding.medium()) {
                    ForEach(playerList, id: \.self) { player in
                        PlayerSelectionView(player: player, isSelected: player == selectedPlayer, selectedItem: $selectedPlayer)
                    }
                }
            }
            
        }
        .padding()
        .toolbar {
            if shouldShowNavigationBar {
                ToolbarItem(placement: .confirmationAction) {
                    CustomButton(type: .plain, title: "Fertig", disabled: selectedPlayer == nil) {
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
        }
        .onChange(of: selectedPlayer) { oldValue, newValue in
            if let newValue {
                action(newValue)
            }
        }
    }
}

struct PlayerSelectionView: View {
    
    var player: Players
    @State var isSelected: Bool = false
    @Binding var selectedItem: Players?
    
    var color: Color {
        if isSelected {
            return .accentColor
        } else {
            return .primary
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                isSelected.toggle()
                selectedItem = isSelected ? player : nil
            }, label: {
                
                VStack(content: {
                    ZStack {
                        Circle()
                            .fill(.background.tertiary)
                        
                        SystemImage.person()
                            .font(.system(size: 40))
                            .foregroundStyle(color)
                            .padding()
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                    
                    Text("\(player.firstName) \(player.lastName)")
                })
            })
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue, newValue != player  {
                isSelected = false
            }
        }
    }
    
}
