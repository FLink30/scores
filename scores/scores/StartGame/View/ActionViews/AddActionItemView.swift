import Foundation
import SwiftUI

struct AddActionItemView: View {
    
    var item: ActionType

    var body: some View {
        HStack(spacing: Padding.large()) {
            item.asImage
                .frame(width: 16)
                .font(.title2)
            Text(item.asString)
                .font(.title2)
            
        }
    }
}
