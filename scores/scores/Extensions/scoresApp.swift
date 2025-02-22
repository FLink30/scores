//
//  scoresApp.swift
//  scores
//
//  Created by Tabea Privat on 06.11.23.
//

import SwiftUI

@main
struct scoresApp: App {
    @State var successful: Bool?
    @State var selectedPlayer: Players?
    
    var body: some Scene {
        WindowGroup {
            LoginView(loginViewModel: LoginViewModel())
                .navigationViewStyle(.stack)
        }
    }
}

fileprivate final class PreviewMockViewModel: RegistrationViewModel {
    override init() { }
}
