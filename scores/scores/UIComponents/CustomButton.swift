import Foundation
import SwiftUI

struct CustomButton: View {
    
    var type: ButtonType
    var title: String?
    var disabled: Bool
    var image: String?
    var isCancelButton: Bool = false
    var action: (() -> ())?
    var size: CGFloat?
    
    
    
    var textColor: Color {
        switch type {
        case .filled:
            if disabled {
                return .gray
            } else {
                return .white
            }
        case .bordered, .plain, .icon:
            if disabled {
                return .gray
            } else {
                if isCancelButton {
                    return .red
                } else {
                    return .blue
                }
                
            }
        }
    }
    
    var backgroundColor: Color {
        switch type {
        case .filled:
            if disabled {
                return .gray.opacity(0.3)
            } else {
                return .blue
            }
        case .bordered, .plain, .icon:
            return .clear
        }
    }
    
    
    var body: some View {
        switch type {
        case .bordered, .filled, .plain:
            
            if let action {
                Text(title ?? "").buttonModifiers(type: type,
                                                  textColor: textColor,
                                                  backgroundColor: backgroundColor)
                .onTapGesture {
                    if !disabled {
                        action()
                    }
                }
            } else {
                Text(title ?? "").buttonModifiers(type: type,
                                                  textColor: textColor,
                                                  backgroundColor: backgroundColor)
            }
        case .icon:
            if let action {
                Image(systemName: image ?? "")
                    .resizable()
                    .buttonModifiers(type: .icon,
                                     textColor: textColor,
                                     backgroundColor: backgroundColor)
                    .font(.system(size: size ?? Padding.medium()))
                    .onTapGesture {
                        action()
                    }
                
                    
                    
            } else {
                Image(systemName: image ?? "")
                    .buttonModifiers(type: .icon,
                                     textColor: textColor,
                                     backgroundColor: backgroundColor)
                    .font(.system(size: size ?? Padding.medium()))
            }
        }
    }
}

fileprivate extension Text {
    func buttonModifiers(type: ButtonType, textColor: Color, backgroundColor: Color) -> some View {
        switch type {
        case .filled:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: 150, minHeight: 30)
                    .background(backgroundColor)
                    .clipShape(Capsule())
            )
        case .bordered:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: 150, minHeight: 30)
                    .background(Capsule()
                        .fill(backgroundColor)
                        .stroke(textColor, style: StrokeStyle(lineWidth: 2)))
            )
        case .plain:
            return AnyView(
                self
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(Padding.small())
                    .frame(minWidth: 150, minHeight: 30)
            )
        default :
            return AnyView(
                self
            )
            
        }
    }
}
fileprivate extension Image {
    func buttonModifiers(type: ButtonType, textColor: Color, backgroundColor: Color) -> some View {
        switch type {
        case .icon:
            return AnyView(
                self
                    .padding(Padding.small())
                    .foregroundColor(textColor)
            )
        default:
            return AnyView(
                self
            )
        }
    }
}

#Preview {
    VStack {
        CustomButton(type: .filled, title: "Test",  disabled: true)
        
        CustomButton(type: .plain, title: "Test", disabled: true)
        
        CustomButton(type: .bordered, title: "Test", disabled: true)
        
        CustomButton(type: .icon, disabled: true, image: "plus")
    
        CustomButton(type: .icon, disabled: true, image: "plus", size: Padding.large())
        
        Divider()
        
        CustomButton(type: .filled, title: "Test",  disabled: false)
        
        CustomButton(type: .plain, title: "Test", disabled: false)
        
        CustomButton(type: .bordered, title: "Test", disabled: false)
        
        CustomButton(type: .icon, disabled: false, image: "plus")
        
        CustomButton(type: .icon, disabled: false, image: "plus", size: Padding.large())
        
    }
}
