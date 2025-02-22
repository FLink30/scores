import Foundation
import SwiftUI

struct PunishmentActionView: View {
    
    @State var selectedPunishmentType: PunishmentType?
    var action: (PunishmentType) -> ()
    
    var body: some View {
        VStack {
            Text("Wähle eine Bestrafung")
                .font(.title2)
                .frame(alignment: .leading)
            HStack(alignment: .top, content: {
                ForEach(PunishmentType.allCases, id: \.self) { type in
                    PunishmentSelectionView(type: type, selectedItem: $selectedPunishmentType)
                }
            })
        }
        .padding()
        .onChange(of: selectedPunishmentType) { oldValue, newValue in
            if let newValue {
                action(newValue)
            }
        }
    }
}

#Preview {
    @State var selectedPunishment: PunishmentType?
    return PunishmentActionView(selectedPunishmentType: selectedPunishment) {_ in 
        
    }
}

struct PunishmentSelectionView: View {
    
    var type: PunishmentType
    @State var isSelected: Bool = false
    @Binding var selectedItem: PunishmentType?
    
    var frameColor: Color {
        if isSelected {
            return .accentColor
        } else {
            return .clear
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                isSelected.toggle()
                selectedItem = isSelected ? type : nil
            }, label: {
                
                VStack(content: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4),
                                         style: .continuous)
                        .fill(.background.tertiary)
                        .stroke(frameColor, lineWidth: 2)
                        
                        type.view
                            .font(.system(size: 40))
                            .padding()
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                })
            })
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue, newValue != type  {
                isSelected = false
            }
        }
    }
    
}
