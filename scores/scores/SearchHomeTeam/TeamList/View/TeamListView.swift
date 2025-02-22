//
//  TeamListView.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import SwiftUI
struct TeamListView: View {
    
    @ObservedObject var searchTeamViewModel: SearchTeamViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isPerformingTeamRegistration: Bool = false
    @State private var isShowingCreateTeamView: Bool = false
    @State private var isShowingMenuView: Bool = false
    
    @State var randomTeam: Teams?
    @State private var alertMessage: String = "Fehler"
    @State private var showAlert = false
    @Binding var opponent: Teams?
    
    var body: some View {
        NavigationView {
            if searchTeamViewModel.isFetchingData {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                VStack {
                    Text("Mannschaft wählen")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // List contains Teams
                    if !searchTeamViewModel.foundedTeams.isEmpty {
                        List(searchTeamViewModel.foundedTeams) { team in
                            HStack {
                                TeamListItemView(searchTeamViewModel: searchTeamViewModel, team: team)
                            }
                        }
                    }else {
                        // List does not contain Teams ////////////////////////////
                        List {
                            Text("Keine Ergebnisse")
                                .padding(Padding.medium())
                                .foregroundColor(.gray)
                        }
                    }
                    CustomButton(type: .bordered,
                                 title: "Wählen",
                                 disabled: !searchTeamViewModel.teamIsCompleted.teamCompleted,
                                 action: chooseTeam)
                    .padding()
                    
                    // Problem: is also displayed, if there are just teams with admins
                    // could be confus for the user
                    Text("* Team hat schon einen Admin")
                        .foregroundStyle(Color.gray)
                    
                }
                .fullScreenCover(isPresented: $isShowingCreateTeamView) {
                    // create new Team with already inserted data
                    CreateTeamView(searchTeamViewModel: searchTeamViewModel,
                                   createOpponentTeam: false,
                                   selectedOpponent: $opponent)
                }
                .fullScreenCover(isPresented: $isShowingMenuView) {
                    // display start View
                    if let team = searchTeamViewModel.retrieveNewTeam() {
                        MenuView(viewModel: StartViewModel(team: team))
                    }
                }
//                .alert(isPresented: $showAlert, error: searchTeamViewModel.errorMessage, actions: {})
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            CreateTeamView(searchTeamViewModel: searchTeamViewModel, 
                                           createOpponentTeam: false, 
                                           selectedOpponent: $randomTeam)
                        } label: {
                            CustomButton(type: .icon,
                                         disabled: false,
                                         image: "plus")
                        }
                    }
                }
            }
        }
    }
    
    func chooseTeam() {
        Task {
            searchTeamViewModel.performTeamUpdate()
            switch searchTeamViewModel.errorMessage {
            case .teamNotFound:
                alertMessage = "Team not found"
                showAlert = true
                isShowingCreateTeamView = true
            case .invalidData:
                alertMessage = "Invalid Data"
                showAlert = true
                isShowingCreateTeamView = true
            case .unexpected:
                alertMessage = "Error"
                showAlert = true
                isShowingCreateTeamView = true
            default:
                isShowingMenuView = true
            }
        }
    }
}
