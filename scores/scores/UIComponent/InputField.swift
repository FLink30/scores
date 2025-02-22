import Foundation
import SwiftUI

struct InputField: View {
    
    @Binding var text: String
    var placeholder: String
    var type: InputFieldType = .default
    @Binding var errorMessage: String?
    var onCommit: () -> ()
    @State var isEditing: Bool = false
    var padding: Padding = .medium
    @FocusState var isFocused: InputType?
    var fieldType: InputType
    
    
    var body: some View {
        VStack {
            if type == .password {
                SecureField(placeholder, text: $text) {
                    onCommit()
                }
                .focused($isFocused, equals: fieldType)
                .textFieldStyle(.roundedBorder)
            } else {
                TextField(placeholder, text: $text) {
                    onCommit()
                }
                .textFieldModifiers(type: type)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused, equals: fieldType)
            }
            
            if let errorMessage {
                if !isEditing {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
            }
        }.padding(padding())
            .onChange(of: isFocused) { oldValue, newValue in
                if isFocused == fieldType {
                    isEditing = true
                } else {
                    isEditing = false
                }
            }
    }
}

fileprivate extension SecureField {
    func textFieldModifiers(type: InputFieldType) -> some View {
        switch type {
        case .password:
            return AnyView(
                self
                    .keyboardType(.default)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            )
        default:
            return AnyView(self)
        }
    }
}

fileprivate extension TextField {
    func textFieldModifiers(type: InputFieldType) -> some View {
        switch type {
        case .email:
            return AnyView(
                self
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            )
        default:
            return AnyView(
                self
                    .keyboardType(.default)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
            )
        }
    }
}
//
//#Preview {
//    @State var inputText = ""
//    @State var errorMessage: String?
//    @State var isEditing: Bool = false
//    return InputField(text: $inputText, placeholder: "Passwort", type: .password, errorMessage: $errorMessage, onCommit: {
//        errorMessage = "ERROR"
//    }, isEditing: isEditing)
//}
