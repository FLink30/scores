import Foundation
import SwiftUI

struct SuccessfulView: View {
    
    @Binding var successful: Bool?
    
    var checkmarkIconColor: Color {
        if let successful, successful {
            return .primary
        } else {
            return .green
        }
    }
    
    var xmarkIconColor: Color {
        if let successful, !successful {
            return .primary
        } else {
            return .red
        }
    }
    
    var body: some View {
        HStack(spacing: Padding.large()) {
            Button(action: {
                if successful == true {
                    self.successful = nil
                } else {
                    self.successful = true
                }
            }, label: {
                ZStack {
                    if successful == true {
                        Circle()
                            .fill(.green)
                    } else {
                        Circle()
                            .fill(.background.tertiary)
                    }
                    
                    
                    SystemImage.checkmark()
                        .font(.system(size: 40))
                        .foregroundStyle(checkmarkIconColor)
                        .padding()
                }
                .frame(maxWidth: 100, maxHeight: 100)
            })
            
            Button(action: {
                if successful == false {
                    self.successful = nil
                } else {
                    self.successful = false
                }
            }, label: {
                ZStack {
                    if successful == false {
                        Circle()
                            .fill(.red)
                    } else {
                        Circle()
                            .fill(.background.tertiary)
                    }
                    
                    SystemImage.xmark()
                        .font(.system(size: 40))
                        .foregroundStyle(xmarkIconColor)
                        .padding()
                }
                .frame(maxWidth: 100, maxHeight: 100)
            })
        }
        .padding(Padding.small())
        
        
    }
}

#Preview {
    @State var successful: Bool?
    return SuccessfulView(successful: $successful)
}
