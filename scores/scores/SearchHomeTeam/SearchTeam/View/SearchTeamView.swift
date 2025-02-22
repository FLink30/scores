//
//  SearchTeamView.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import SwiftUI

struct SearchTeamView: View {
    @ObservedObject var searchTeamViewModel: SearchTeamViewModel
    
    var background = Color.gray
    @State var showingSheet = false
    @FocusState var focusedField: InputType?
    @State private var isShowingTeamListView: Bool = false
    @State private var isShowingCreateTeamView: Bool = false
    
    @State var randomTeam: Teams?
    @State private var alertMessage: String? = "Fehler"
    @State var error: String? = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                // if viewmodel is fetching data there should be a progressView
                // that user can't do something
                if searchTeamViewModel.isFetchingData {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    VStack(spacing: Padding.prettySmall()){
                        Spacer(minLength: Padding.large())
                        
                        InputField(
                            text: $searchTeamViewModel.selectedSex,
                            placeholder: "Geschlecht",
                            type: .default ,
                            errorMessage: $error,
                            onCommit: {
                            },
                            isFocused: _focusedField,
                            fieldType: .sex)
                        
                        InputField(
                            text: $searchTeamViewModel.selectedAssociation,
                            placeholder: "Verband",
                            type: .default,
                            errorMessage: $error,
                            onCommit: {
                            },
                            isFocused: _focusedField,
                            fieldType: .association)
                        
                        InputField(
                            text: $searchTeamViewModel.selectedLeague,
                            placeholder: "Liga",
                            type: .default,
                            errorMessage: $error,
                            onCommit: {
                            },
                            isFocused: _focusedField,
                            fieldType: .league)
                        
                        InputField(
                            text: $searchTeamViewModel.selectedSeason,
                            placeholder: "Season",
                            type: .default,
                            errorMessage: $error,
                            onCommit: {
                            },
                            isFocused: _focusedField,
                            fieldType: .season)
                    }
                    Spacer(minLength: Padding.prettyLarge())
                    
                    CustomButton(
                        type: .filled,
                        title: "Suchen",
                        disabled: !searchTeamViewModel.teamIsCompleted.inputValid,
                        action: search)
                }
            } .onChange(of: focusedField) { _, newValue in
                if newValue == nil {
                    showingSheet = false
                } else {
                    showingSheet = true
                }
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                searchTeamViewModel.dismissSheet(type: self.focusedField)
            }, content: {
                switch focusedField {
                case .sex:
                    PickerSheetView <Sex>(selectedItem: $searchTeamViewModel.sex)
                        .presentationDetents([.fraction(0.3)])
                case .association:
                    PickerSheetView <Association>(selectedItem: $searchTeamViewModel.association)
                        .presentationDetents([.fraction(0.3)])
                case .league:
                    PickerSheetView <League>(selectedItem: $searchTeamViewModel.league)
                        .presentationDetents([.fraction(0.3)])
                case .season:
                    PickerSheetView <Season>(selectedItem: $searchTeamViewModel.season)
                        .presentationDetents([.fraction(0.3)])
                default:
                    Text("Error")
                }
            })
            .navigationTitle("Mannschaft suchen")
            
            // depending on whether teams were founded or not, will be displayed another ScreenCover
            .fullScreenCover(isPresented: $isShowingTeamListView) {
                // displays the founded teams
                TeamListView(searchTeamViewModel: searchTeamViewModel,
                             opponent: $randomTeam)
            }
            .fullScreenCover(isPresented: $isShowingCreateTeamView) {
                // create new Team with already inserted data
                CreateTeamView(searchTeamViewModel: searchTeamViewModel,
                               createOpponentTeam: false,
                               selectedOpponent: $randomTeam)
            }
        }
    }
    
    func search() {
        Task {
            searchTeamViewModel.performSearch()
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
                isShowingTeamListView = true
            }
        }
    }
}
