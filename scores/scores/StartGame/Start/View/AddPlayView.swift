import Foundation
import SwiftUI

struct AddPlayView: View {
    
    @ObservedObject var viewModel: AddPlayViewModel = AddPlayViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedColor: Color = .black
    private var hexValue: String {
        selectedColor.toHex()
    }
    
    var action: (Play) -> ()
    
    var body: some View {
        VStack {
            InputField(
                text: $viewModel.playName,
                placeholder: "Spielzug-Name",
                type: .default,
                errorMessage: $viewModel.errorMessage,
                onCommit: {},
                fieldType: .playName
                
            )
            
            ColorPicker("Wähle eine Farbe", 
                        selection: $selectedColor,
                        supportsOpacity: false)
                .padding()
            
            CustomButton(type: .filled,
                         title: "Erstellen",
                         disabled: !viewModel.isInputValid,
                         action: {
                let play = Play(name: viewModel.playName, color: hexValue)
                action(play)
                presentationMode.wrappedValue.dismiss()
            })
            .padding()
        }
        .navigationTitle("Spielzug erstellen")
    }
}

extension Color {
    func toHex() -> String {
        guard let components = cgColor?.components, components.count >= 3 else { return "" }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let hexString = String(
            format: "#%02lX%02lX%02lX",
            lroundf(red * 255),
            lroundf(green * 255),
            lroundf(blue * 255)
        )
        
        return hexString
    }
    
    static func fromHex(_ hex: String) -> Color {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0

            return Color(red: red, green: green, blue: blue)
        }
}
