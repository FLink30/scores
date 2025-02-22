import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var credentialsValid: Bool = false
    
    
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    var adminID: UUID?
    
    private var isInputValid: Bool {
        emailErrorMessage == nil && passwordErrorMessage == nil
    }
    
    @Published var alert: String?
    
    var team: Teams?
    var profile: Profile?
    
    init() {
        setUpObservation()
    }
    
    func setUpObservation () {
        $email
            .removeDuplicates()
            .sink { email in
                if email.isEmpty {
                    self.emailErrorMessage = nil
                } else {
                    if email.isValidEmailAddress {
                        self.emailErrorMessage = nil
                    } else {
                        self.emailErrorMessage = ErrorMessage.email()
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
        
        $email
            .removeDuplicates()
            .combineLatest($password)
            .map { email, password in
                return !email.isEmpty && !password.isEmpty && self.passwordErrorMessage == nil && self.emailErrorMessage == nil
            }
            .assign(to: &$credentialsValid)
    }
    
    func performLogin() async -> Result<Teams?, LoginViewModelError> {
        guard credentialsValid else { return .failure(.inputInvalid) }
        do {
            let loginProvider = CloudServiceManager.shared.loginProvider
            let adminID = try await loginProvider.signIn(email: email, password: password)
            
            var team = try await self.retrieveTeam(id: adminID)
            let profile = try await self.retrieveProfile()
            self.profile = profile
            team.adminID = adminID
            self.team = team
            DispatchQueue.main.async {
                self.adminID = adminID
                
                self.profile = profile
            }
            
            return .success(team)
        } catch let error as TeamsServiceError {
            if case .teamNotFound = error.teamsRequestError {
                return .success(nil)
            } else {
                return .failure(.teamsServiceError(error))
            }
            
        } catch let error as LoginServiceError {
            return .failure(.loginRequestError(error.loginRequestError))
        } catch {
            return .failure(.loginRequestError(LoginRequestError.unexpected("\(error)")))
        }
    }
    
    private func retrieveTeam(id: UUID) async throws -> Teams {
        let teamsProvider = CloudServiceManager.shared.teamsProvider
        return try await teamsProvider.getTeamByID(adminID: id)
    }
    
    private func retrieveProfile() async throws -> Profile {
        let profileProvider = CloudServiceManager.shared.profileProvider
        return try await profileProvider.getProfile()
    }
}

enum LoginViewModelError: Error {
    case loginRequestError(LoginRequestError)
    case teamsServiceError(TeamsServiceError)
    case inputInvalid
}
