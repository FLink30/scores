import SwiftUI

struct ProfileView: View {
    
    @State var showLoginView: Bool = false
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            CustomButton(type: .bordered, title: "Abmelden", disabled: false, action: {
                do {
                    try AuthenticationManager.removeCloudIdentity()
                    showLoginView = true
                } catch {
                    self.errorMessage = "Beim Ausloggen ist etwas schief gegangen. Versuch es später erneut."
                    self.showAlert = true
                }
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Fehler"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView(loginViewModel: LoginViewModel())
        }
        
    }
}
