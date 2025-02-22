import Foundation
import SwiftUI

struct CustomButton: View{
    
    var type: ButtonType
    var title: String
    var disabled: Bool
    var action: () -> ()
    
    var small: Padding = .small
    
    init(type: ButtonType, title: String, disabled: Bool, action: @escaping () -> ()) {
           self.type = type
           self.title = title
           self.disabled = disabled
           self.action = action
       }
    
    
    var body: some View {
        switch type {
            
        case .filled:
            Button(action: action) {
                Text(title)
                    .frame(minWidth: 150, minHeight: 30)
            }
                .padding(small())
                .buttonStyle(.borderedProminent)
                .disabled(disabled)
        case .plain:
            Button(action: action) {
                Text(title)
                    .frame(minWidth: 150, minHeight: 30)
            }
                .padding(small())
                .frame(minWidth: 150, minHeight: 30)
                .disabled(disabled)
        }
    }
}

#Preview {
    VStack {
        CustomButton(type: .filled, title: "Test",  disabled: true) {
        }
        
        CustomButton(type: .plain, title: "Test", disabled: true) {
        }
    }
}
