import SwiftUI

class ApplicationFlowCoordinator {

    enum Route {
        case login
       // case posts([String])
        case registration
    }
    
    private var loginViewModel: LoginViewModel!
    private var registrationViewModel: RegistrationViewModel!
    
    private func loginView() -> AnyView {
            loginViewModel = LoginViewModel()
            return LoginView(loginViewModel: loginViewModel).toAnyView()
        }
    
    private func registrationView() -> AnyView {
        registrationViewModel = RegistrationViewModel()
        return RegistrationView(registrationViewModel: registrationViewModel).toAnyView()
    }

    func view(for route: Route) -> AnyView {
        switch route {
        case .login:
            return loginView()
        case .registration:
            return registrationView()
        }
    }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

extension ApplicationFlowCoordinator {
    static let previewCoordinator = ApplicationFlowCoordinator()
}
