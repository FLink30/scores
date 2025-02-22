//
//  TeamNotFoundView.swift
//  scores
//
//  Created by Franziska Link on 19.12.23.
//

import SwiftUI

struct CreateTeamView: View {
    @ObservedObject var searchTeamViewModel: SearchTeamViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isPerformingCreateTeam: Bool = false
    @State var isShowingMenuView: Bool = false
    @State var isShowingSearchOpponentView: Bool = false
    
    @State private var alertMessage: String?
    @State private var showAlert = false
    var createOpponentTeam: Bool
    @Binding var selectedOpponent: Teams?
    
    var body: some View {
        NavigationView {
            ScrollView {
                // if viewmodel is fetching data there should be a progressView
                // that user can't do something
                if searchTeamViewModel.isFetchingData {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    VStack {
                        if(createOpponentTeam) {
                            Text("Gegner erstellen")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Wappen")
                            .resizable()
                            .frame(maxWidth: 200, maxHeight: 200)
                        InputField(
                            text: $searchTeamViewModel.teamName,
                            placeholder: "Name der Mannschaft",
                            type: .default,
                            errorMessage: $alertMessage,
                            onCommit:{
                            }, isEditing: true,
                            fieldType: .teamName
                        )
                        CustomButton(type: .filled,
                                     title: "Erstellen",
                                     disabled: !searchTeamViewModel.teamIsCompleted.inputValid,
                                     action: {
                            register()
                        })
                        .padding(Padding.medium())
                    }
                    .toolbar {
                        // Toolbar for creating a new home team
                        if(!createOpponentTeam) {
                            ToolbarItem(placement: .principal) {
                                VStack(spacing: Padding.large()) {
                                    Text("Deine Mannschaft wurde nicht gefunden").font(.headline)
                                    Text("Bitte erstelle nun deine Mannschaft")
                                }
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingMenuView) {
                        // displays menu view
                        if let team = searchTeamViewModel.retrieveNewTeam() {
                            MenuView(viewModel: StartViewModel(team: team))
                        }
                        
                    }
                }
            }
        }
    }
    
    func register() {
        searchTeamViewModel.isFetchingData = true
        
        Task {
            let result = await searchTeamViewModel.postData()
            switch result {
            case .success(let team):
                DispatchQueue.main.async {
                    self.searchTeamViewModel.isFetchingData = false
                    self.selectedOpponent = team
                    self.presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.searchTeamViewModel.errorMessage = error
                }
            }
            DispatchQueue.main.async {
                self.searchTeamViewModel.isFetchingData = false
            }
            
            switch searchTeamViewModel.errorMessage {
            case .teamNotFound:
                alertMessage = "Error"
                showAlert = true
            case .invalidData:
                alertMessage = "Invalid Data"
                showAlert = true
            case .unexpected:
                alertMessage = "Error"
                showAlert = true
            default:
                if(createOpponentTeam){
                    presentationMode.wrappedValue.dismiss()
                } else {
                    isShowingMenuView = true
                }
            }
            
        }
    }
}
