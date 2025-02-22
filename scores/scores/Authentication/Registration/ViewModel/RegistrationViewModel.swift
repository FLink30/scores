//
//  AuthenticationViewModel.swift
//  scores
//
//  Created by Tabea Privat on 05.12.23.
//

import Foundation
import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var userID: UUID?
    @Published var firstName: String
    @Published var firstNameErrorMessage: String?
    @Published var lastName: String
    @Published var lastNameErrorMessage: String?
    @Published var email: String
    @Published var emailErrorMessage: String?
    @Published var password: String
    @Published var passwordErrorMessage: String?
    @Published var repeatedPassword: String
    @Published var repeatedPasswordErrorMessage: String?
    @Published var isRegistrationPerformable: Bool = false
    
    @Published var isNameEntered: Bool = false
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var credentialsValid: Bool = false
    
    private var isInputValid: Bool {
        firstNameErrorMessage == nil
        && lastNameErrorMessage == nil
        && emailErrorMessage == nil
        && passwordErrorMessage == nil
        && repeatedPasswordErrorMessage == nil
    }
    
    init() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        repeatedPassword = ""
        setupObservation()
    }
    
    func performRegistration() async -> Result<Void, RegistrationViewModelError> {
        guard isInputValid else { return .failure(.inputInvalid) }
        do {
            let registrationProvider = CloudServiceManager.shared.registrationProvider
            _ = try await registrationProvider.register(email: email, password: password, firstName: firstName, lastName: lastName)
            
            let loginProvider = CloudServiceManager.shared.loginProvider
            let adminID = try await loginProvider.signIn(email: email, password: password)
            DispatchQueue.main.async {
                self.userID = adminID
            }
            return .success(())
        } catch let error as RegistrationServiceError {
            return .failure(.registrationRequestError(error.registrationRequestError))
        } catch {
            return .failure(.registrationRequestError(RegistrationRequestError.unexpected("\(error)")))
        }
    }
    
    private func setupObservation() {
        $firstName
            .removeDuplicates()
            .sink { name in
                if name.isEmpty {
                    self.firstNameErrorMessage = nil
                } else {
                    if name.isValidName {
                        self.firstNameErrorMessage = nil
                    } else {
                        self.firstNameErrorMessage = ErrorMessage.firstName()
                    }
                }
            }
            .store(in: &cancellables)
        
        $lastName
            .removeDuplicates()
            .sink { name in
                if name.isEmpty {
                    self.lastNameErrorMessage = nil
                } else {
                    if name.isValidName {
                        self.lastNameErrorMessage = nil
                    } else {
                        self.lastNameErrorMessage = ErrorMessage.lastName()
                    }
                }
            }
            .store(in: &cancellables)
        
        $password
            .removeDuplicates()
            .sink { password in
                if password.isEmpty {
                    self.passwordErrorMessage = nil
                } else {
                    if password.isValidPassword {
                        self.passwordErrorMessage = nil
                    } else {
                        self.passwordErrorMessage = ErrorMessage.inputInvalid()
                    }
                }
            }
            .store(in: &cancellables)
        
        $repeatedPassword
            .removeDuplicates()
            .sink { password in
                if password.isEmpty {
                    self.repeatedPasswordErrorMessage = nil
                } else {
                    if password.isValidPassword {
                        self.repeatedPasswordErrorMessage = nil
                    } else {
                        self.repeatedPasswordErrorMessage = ErrorMessage.inputInvalid()
                    }
                }
            }
            .store(in: &cancellables)
        
        $firstName
            .removeDuplicates()
            .combineLatest($lastName)
            .map { firstName, lastName in
                !firstName.isEmpty && !lastName.isEmpty
            }.assign(to: &$isNameEntered)
        
        $email
            .removeDuplicates()
            .sink { email in
                if email.isEmpty {
                    self.emailErrorMessage = nil
                    self.isEmailValid = false
                } else {
                    if email.isValidEmailAddress {
                        self.emailErrorMessage = nil
                        self.isEmailValid = true
                    } else {
                        self.isEmailValid = false
                        self.emailErrorMessage = ErrorMessage.email()
                    }
                }
            }
            .store(in: &cancellables)
        
        $password
            .removeDuplicates()
            .sink { password in
                if !password.isEmpty && password.count < 8 {
                    self.passwordErrorMessage = ErrorMessage.password()
                } else {
                    self.passwordErrorMessage = nil
                }
            }
            .store(in: &cancellables)
        
        $repeatedPassword
            .removeDuplicates()
            .combineLatest($password)
            .sink { repeatedPassword, password in
                if password.isEmpty || repeatedPassword.isEmpty {
                    self.repeatedPasswordErrorMessage = nil
                    self.isPasswordValid = false
                } else {
                    if repeatedPassword == password {
                        self.repeatedPasswordErrorMessage = nil
                        self.isPasswordValid = true
                    } else {
                        self.isPasswordValid = false
                        self.repeatedPasswordErrorMessage = ErrorMessage.repeatedPassword()
                    }
                }
            }
            .store(in: &cancellables)
        
        $isPasswordValid
            .removeDuplicates()
            .combineLatest($isEmailValid)
            .map { isPasswordValid, isEmailValid in
                isPasswordValid && isEmailValid
            }.assign(to: &$credentialsValid)
        
        $credentialsValid
            .removeDuplicates()
            .combineLatest($isNameEntered)
            .map { credentialsValid, isNameEntered in
                if self.isInputValid {
                    return credentialsValid && isNameEntered
                } else {
                    return false
                }
            }.assign(to: &$isRegistrationPerformable)
    }
}

enum ErrorMessage {
    case firstName
    case lastName
    case email
    case password
    case repeatedPassword
    case inputInvalid
    
    func callAsFunction() -> String {
        switch self {
        case .firstName, .lastName:
            return "Name ungültig"
        case .email:
            return "Email ungültig oder bereits verwendet"
        case .password:
            return "Passwort ungültig"
        case .repeatedPassword:
            return "Passwörter stimmen nicht überein"
        case .inputInvalid:
            return "Eingabe ungültig"
        }
    }
}

enum RegistrationViewModelError: Error {
    case registrationRequestError(RegistrationRequestError)
    case inputInvalid
}

