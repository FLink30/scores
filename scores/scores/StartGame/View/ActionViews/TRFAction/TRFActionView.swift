import Foundation
import SwiftUI

struct TRFActionView: View {

    @State var selectedPlayItem: Play?
    
    var playList: [Play]
    
    var action: (Play?) -> ()

    var body: some View {
        VStack {
            Text("Willst du einen Spielzug hinzufügen?")
                .font(.title2)
                .frame(alignment: .leading)
            HStack() {
                Button {
                    action(nil)
                } label: {
                    PlayListItemHelperView(type: .none)
                }
                .buttonStyle(.plain)
                PlayListView(playList: playList, selectedPlay: $selectedPlayItem)
            }
        }
        .padding()
        .onChange(of: selectedPlayItem) { oldValue, newValue in
            if let newValue {
                action(newValue)
            }
        }
    }
}

struct PlayListItemHelperView: View {
    
    var type: PlayListItemHelperType
    
    var image: Image {
        switch type {
        case .add:
            SystemImage.plus()
        case .none:
            SystemImage.xmark()
        }
    }

    var body: some View {
        Rectangle()
            .stroke(.secondary, lineWidth: 5) // Rahmen
            .background(
                image
                    .font(.system(size: 40))
            )
            .background(.clear)
        .frame(width: 100, height: 100)
        .buttonStyle(.plain)
    }
}

enum PlayListItemHelperType {
    case add
    case none
}
