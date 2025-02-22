import Foundation
import SwiftUI

struct GoalGridView: View {
    
    @Binding var selectedItem: Int?
    
    var body: some View {
        VStack {
            ForEach(1..<4) { row in
                HStack {
                    ForEach(0..<3) { column in
                        let number = (row - 1) * 3 + column
                        GoalGridItemView(number: number, selectedItem: $selectedItem)
                    }
                }
            }
        }
        .padding(Padding.small())
        
        
    }
}

#Preview {
    @State var selectedItem: Int?
    return GoalGridView(selectedItem: $selectedItem)
}

struct GoalGridItemView: View {
    
    var number: Int
    
    
    @State var isSelected: Bool = false
    @Binding var selectedItem: Int?
    
    var body: some View {
        VStack {
            Button(action: {
                isSelected.toggle()
                selectedItem = isSelected ? number : nil
            }, label: {
                Rectangle()
                    .stroke(.secondary, lineWidth: 1) // Rahmen
                    .background(
                        Group {
                            if isSelected {
                                SystemImage.xmark()
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.accentColor)
                            } else {
                                Color.clear
                            }
                        }
                    )
                    .background(.background.secondary)
            })
            .buttonStyle(.plain)
            
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue, newValue != number  {
                isSelected = false
            }
        }
    }
}
