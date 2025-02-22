//
//  Registration.swift
//  scores
//
//  Created by Franziska Link on 04.12.23.
//

import SwiftUI

struct RegistrationView<ViewModel: RegistrationViewModel>: View {
    
    @ObservedObject var viewModel: RegistrationViewModel
    @FocusState var focusedField: InputType?
    @State private var isPerformingRegistration = false
    @State private var showAlert = false
    @State private var alertMessage: String = "Fehler"
    @State private var shouldNavigateToTeamRegistration: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack() {
                    
                    InputField(
                        text: $viewModel.firstName,
                        placeholder: "Vorname",
                        type: .default,
                        errorMessage: $viewModel.firstNameErrorMessage,
                        onCommit: {
                            self.focusedField = .lastName
                        }, isFocused: _focusedField,
                        fieldType: .firstName
                        
                    )
                    
                    InputField(
                        text: $viewModel.lastName,
                        placeholder: "Nachname",
                        type: .default,
                        errorMessage: $viewModel.lastNameErrorMessage,
                        onCommit: {
                            self.focusedField = .email
                        }, isFocused: _focusedField,
                        fieldType: .lastName
                    )
                    
                    InputField(
                        text: $viewModel.email,
                        placeholder: "Email",
                        type: .email,
                        errorMessage: $viewModel.emailErrorMessage,
                        onCommit: {
                            self.focusedField = .password
                        }, isFocused: _focusedField,
                        fieldType: .email
                    )
                    
                    InputField(
                        text: $viewModel.password,
                        placeholder: "Passwort",
                        type: .password,
                        errorMessage: $viewModel.passwordErrorMessage,
                        onCommit: {
                            self.focusedField = .repeatedPassword
                        }, isFocused: _focusedField,
                        fieldType: .password
                    )
                    
                    InputField(
                        text: $viewModel.repeatedPassword,
                        placeholder: "Passwort wiederholen",
                        type: .password,
                        errorMessage: $viewModel.repeatedPasswordErrorMessage,
                        onCommit: {
                            self.register()
                        }, isFocused: _focusedField,
                        fieldType: .repeatedPassword
                    )
                    
                    CustomButton(type: .filled, title: "Registrieren", disabled: !viewModel.isRegistrationPerformable, action:  {
                        self.register()
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Fehler"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK")))
                    }
                }
                .navigationTitle("Registriere Dich")
                .fullScreenCover(isPresented: $shouldNavigateToTeamRegistration) {
                    if let userID = viewModel.userID {
                        SearchTeamView(searchTeamViewModel: SearchTeamViewModel(adminID: userID))
                    }
                    
                }
            }
        }.disabled(isPerformingRegistration)
    }
    private func register() {
        self.isPerformingRegistration = true
        Task {
            let result = await viewModel.performRegistration()
            switch result {
            case .success:
                shouldNavigateToTeamRegistration = true
                break
            case .failure(let error):
                switch error {
                case .registrationRequestError(let error):
                    switch error {
                    case .invalidData:
                        self.alertMessage = "Invalide Daten"
                    case .unexpected(let string):
                        self.alertMessage = string ?? "Fehler"
                    }
                case .inputInvalid:
                    self.alertMessage = "Eingabe ist nicht valide"
                }
                self.showAlert = true
            }
        }
        self.isPerformingRegistration = false
    }
}

fileprivate final class PreviewMockViewModel: RegistrationViewModel {
    override init() { }
}

#Preview {
    RegistrationView(viewModel: PreviewMockViewModel())
}
