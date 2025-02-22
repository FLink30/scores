//
//  LoginView.swift
//  scores
//
//  Created by Franziska Link on 27.11.23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    
    @State
    var displayRegistrationView = false
    @FocusState var focusedField: InputType?
    @State private var isPerformingLogin = false
    @State private var showAlert = false
    @State private var alertMessage: String = "Fehler"
    
    @State private var shouldNavigateToMenu: Bool = false
    @State private var shouldNavigateToTeamRegistration: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack (spacing: Padding.small()) {
                    Spacer(minLength: Padding.large())
                    InputField(
                        text: $loginViewModel.email,
                        placeholder: "Emailadresse",
                        type: .email,
                        errorMessage: $loginViewModel.emailErrorMessage,
                        onCommit: {
                            self.focusedField = .password
                        }, isFocused: _focusedField,
                        fieldType: .email)
                    
                    InputField(
                        text: $loginViewModel.password,
                        placeholder: "Passwort",
                        type: .password,
                        errorMessage:  $loginViewModel.passwordErrorMessage,
                        onCommit: {
                            self.login()
                        }, isFocused: _focusedField,
                        fieldType: .password)
                    
                    Divider()
                    Spacer(minLength: Padding.large())
                }
                
                VStack(spacing: Padding.large()) {
                    
                    CustomButton(
                        type: .filled,
                        title: "Anmelden",
                        disabled: false,
                        action: login)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Fehler"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    NavigationLink(destination: RegistrationView(viewModel: RegistrationViewModel()), label: {
                        
                        CustomButton(
                            type: .bordered,
                            title: "Registieren",
                            disabled: false)
                    })
                }
                
            }
            .fullScreenCover(isPresented: $shouldNavigateToMenu) {
                MenuView(viewModel: StartViewModel(team: loginViewModel.team!))
            }
            .fullScreenCover(isPresented: $shouldNavigateToTeamRegistration) {
                SearchTeamView(searchTeamViewModel: SearchTeamViewModel(adminID: loginViewModel.adminID))
            }
            .navigationTitle("Melde dich an")
        }
        .disabled(isPerformingLogin)
    }
    
    func login() {
        self.isPerformingLogin = true
        Task {
            let result = await loginViewModel.performLogin()
            switch result {
            case .success(let team):
                shouldNavigateToMenu = team != nil
                shouldNavigateToTeamRegistration = team == nil
                
            case .failure(let error):
                switch error {
                case .loginRequestError(let error):
                    switch error {
                    case .invalidData:
                        self.alertMessage = "Invalide Daten"
                    case .wrongPassword:
                        self.alertMessage = "falsches Passwort"
                    case .userNotFound:
                        self.alertMessage = "User wurde nicht gefunden"
                    case .unexpected(let string):
                        self.alertMessage = string ?? "Fehler"
                    }
                case .teamsServiceError:
                    self.alertMessage = "Fehler"
                case .inputInvalid:
                    self.alertMessage = "Eingabe ist nicht valide"
                }

                self.showAlert = true
            }
        }
        self.isPerformingLogin = false
    }
    
    func register() {
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
}
