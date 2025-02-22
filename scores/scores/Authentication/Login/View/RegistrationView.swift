//
//  RegistrationView.swift
//  scores
//
//  Created by Franziska Link on 27.12.23.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var registrationViewModel: RegistrationViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RegistrationView(registrationViewModel: RegistrationViewModel())
}
