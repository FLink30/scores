//
//  LoginView.swift
//  scores
//
//  Created by Franziska Link on 27.11.23.
//

import SwiftUI

struct LoginView: View {
    @State
    var emailAddress = ""
    @State
    var passwort = ""
    @State
    var errorMessage = ""
    
    
    var padding_ps: Padding = .prettySmall
    var padding_l: Padding = .large
    var padding_pl: Padding = .prettyLarge
    
    @State
    var displayRegistrationView = false
    

    
    var body: some View {
        NavigationView {
            ScrollView{
                Spacer(minLength: padding_pl())
                VStack (spacing: padding_ps()) {
                    
//                    InputField(text: $emailAddress, placeholder: "Emailadresse", type: .email, errorMessage: errorMessage, onCommit: {
//                        errorMessage = "ERROR"
//                    })
//                    InputField(text: $passwort, placeholder: "Passwort", type: .password, errorMessage: errorMessage, onCommit: {
//                        errorMessage = "ERROR"
//                    })
                    NavigationLink(destination: ForgotPasswortView()){
                        Text("Passwort vergessen?")
                    }
                }
                
                Spacer(minLength: padding_pl())
                
                VStack( spacing: padding_l()) {
                    CustomButton(type: .filled, title: "Anmelden", disabled: emailAddress.isEmpty || passwort.isEmpty, action: signIn)
            
                    CustomButton(type: .filled, title: "Registieren", disabled: false, action: register)
                }
            }
                
                
                    .navigationTitle("Melde dich an")
            }
                
        }
    
    
        
        func signIn() -> Void {
         
         }
         
    
        func register() -> Void {
          
        }
}

    
    #Preview {
    LoginView()
}
