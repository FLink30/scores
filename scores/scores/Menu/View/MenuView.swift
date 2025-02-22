//
//  MenuView.swift
//  scores
//
//  Created by Franziska Link on 05.01.24.
//

import SwiftUI

struct MenuView: View {
    var viewModel: StartViewModel
    var body: some View {
        NavigationStack {
            
            TabView {
                NavigationView {
                    StartView(viewModel: viewModel)
                        .navigationBarTitleDisplayMode(.large)
                    
                }
                .tabItem {
                    Label("Start", systemImage: "house")
                }
                
                NavigationView {
                    GamesListView(gamesListViewModel: GamesListViewModel(team: viewModel.team))
                        .navigationTitle("Spiele")
                }
                .tabItem {
                    Label("Spiele", systemImage: "figure.handball")
                }
                
                NavigationView {
                    ProfileView()
                        .navigationTitle("Profil")
                }
                .tabItem {
                    Label("Profil", systemImage: "person")
                    
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
