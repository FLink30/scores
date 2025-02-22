//
//  ForgotPasswortView.swift
//  scores
//
//  Created by Franziska Link on 04.12.23.
//

import SwiftUI

struct ForgotPasswortView: View {
    @State
    var emailAddress = ""
    @State
    var errorMessage = ""
    
    
    var padding_l: Padding = .large
    
    var body: some View {
        ScrollView {
            VStack(spacing: padding_l()) {
                Spacer(minLength: padding_l())
                Text("Bitte Emailadresse eingeben:")
                    .font(.title)
//                InputField(text: $emailAddress, placeholder: "Emailadresse", type: .email, errorMessage: errorMessage, onCommit: {
//                    errorMessage = "ERROR"
//                })
                CustomButton(type: .filled, title: "Code anfordern", disabled: false, action: provideCode)
            }
            
        }
    }
    
    func provideCode(){
        
    }
}

#Preview {
    ForgotPasswortView()
}
