import Foundation
import SwiftUI

struct PlayListView: View {
    var playList: [Play]
    @Binding var selectedPlay: Play?
    @State private var selectedIndex: Int?
    var isDisabled: Bool = false
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: Padding.medium()) {
                ForEach(playList.indices, id: \.self) { index in
                    PlayListItemView(play: playList[index], isSelected: index == selectedIndex) {
                        if !isDisabled {
                            selectedIndex = index
                            selectedPlay = playList[index]
                        }
                        
                    }
                }
            }
            .padding(Padding.small())
        }
    }
}

struct PlayListItemView: View {
    var play: Play
    var isSelected: Bool
    var action: () -> Void
    
    var fontWeight: Font.Weight {
        if isSelected {
            return .bold
        } else {
            return .regular
        }
    }
    
    var backgroundColor: Color {
        if isSelected {
            return Color.fromHex(play.color).opacity(0.8)
        } else {
            return .clear
        }
    }
    
    var textColor: Color {
        if isSelected {
            return .primary
        } else {
            return .primary
        }
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack {
                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4),
                                 style: .circular)
                    .stroke(Color.fromHex(play.color), lineWidth: 5)
                    .background(
                        Text(play.name)
                            .foregroundStyle(textColor)
                            .fontWeight(fontWeight)
                            .padding(Padding.small())
                    )
                    .background(backgroundColor)
                    .frame(width: 100, height: 100)
            }
            
        })
        .buttonStyle(.plain)
    }
}
