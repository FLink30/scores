//
//  ContentView.swift
//  scores
//
//  Created by Tabea Privat on 06.11.23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        MenuView(viewModel: StartViewModel(team: Teams()))
    }
}

#Preview {
    ContentView()
}
