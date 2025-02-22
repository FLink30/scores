//
//  SearchTeamViewModel.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import Foundation
import SwiftUI
import Combine

struct TeamCompleted {
    var teamNameValid: Bool = false
    var sexValid: Bool = false
    var associationValid: Bool = false
    var leagueValid: Bool = false
    var seasonValid: Bool = false
    
    var teamCompleted: Bool {
        teamNameValid && sexValid && associationValid && leagueValid && seasonValid
    }
    
    var inputValid: Bool {
        sexValid && associationValid && leagueValid && seasonValid
    }
}

class SearchTeamViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // adminID for creating a new Team in CreateTeamView
    var adminID: UUID?
    
    @Published var teamName: String = ""
    @Published var sex: Sex?
    @Published var selectedSex: String = ""
    @Published var association: Association?
    @Published var selectedAssociation: String = ""
    @Published var league: League?
    @Published var selectedLeague: String = ""
    @Published var season: Season?
    @Published var selectedSeason: String = ""
    
    @Published var team: Teams?
    @Published var teamIsCompleted = TeamCompleted()
    
    @Published var errorMessage: TeamsRequestError?
    @Published var foundedTeams: [Teams] = []
    
    @Published var isFetchingData: Bool = false
    
    init(adminID: UUID?,
         sex: Sex? = nil,
         association: Association? = nil,
         league: League? = nil,
         season: Season? = nil) {
        setupObservation()
        self.sex = sex
        self.association = association
        self.league = league
        self.season = season
        self.adminID = adminID
        
    }
    
    // Set up Publisher-Subscriber-relationships
    // Realtionships enables to observe published properties and to react
    private func setupObservation() {
        $teamName
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { teamName in
                if teamName.isEmpty {
                    self.teamIsCompleted.teamNameValid = false
                } else {
                    self.teamIsCompleted.teamNameValid = true
                }
            }
            .store(in: &cancellables)
        // $sex returns published Publisher for property ses
        $sex
        // just one value is published, if it differs from the value before
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
        // reacts on changes - is just called when sex is not nil
            .compactMap({$0})
            .sink { sex in
                self.selectedSex = sex()
                self.teamIsCompleted.sexValid = true
            }
        // save changes
            .store(in: &cancellables)
        
        $association
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap({$0})
            .sink { association in
                self.selectedAssociation = association()
                self.teamIsCompleted.associationValid = true
            }
            .store(in: &cancellables)
        
        $league
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap({$0})
            .sink { league in
                self.selectedLeague = league()
                self.teamIsCompleted.leagueValid = true
            }
            .store(in: &cancellables)
        $season
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .compactMap({$0})
            .sink { season in
                self.selectedSeason = season()
                self.teamIsCompleted.seasonValid = true
            }
            .store(in: &cancellables)
    }
    
    func performSearch() {
        isFetchingData = true
        Task {
            let result = await fetchData()
            switch result {
            case .success(let teamList):
                DispatchQueue.main.async {
                    self.foundedTeams = teamList
                    self.isFetchingData = false
                }
            case .failure(let error):
                errorMessage = error
            }
        }
        isFetchingData = false
    }
    
    func retrieveOpponentTeam() -> Teams? {
        if let association, let league, let season, let sex, !teamName.isEmpty {
            return Teams(teamName: teamName, sex: sex, association: association, league: league, season: season, adminID: nil)
        }
        return nil
    }
    
    func performTeamUpdate() {
        isFetchingData = true
        Task {
            let result = await updateData()
            switch result {
            case .success(()):
                DispatchQueue.main.async {
                    self.isFetchingData = false
                }
            case .failure(let error):
                errorMessage = error
            }
        }
        isFetchingData = false
    }
    
    func fetchData() async -> Result<[Teams], TeamsRequestError> {
        do {
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            if let association, let league, let season {
                let foundedTeams = try await teamsProvider.findTeams(association: association,
                                                                     league: league,
                                                                     series: season)
                self.foundedTeams = foundedTeams
                return .success(foundedTeams)
            } else {
                return .failure(.invalidData)
            }
            
        } catch let error as TeamsServiceError {
            return .failure(error.teamsRequestError)
        } catch {
            return .failure(TeamsRequestError.unexpected("\(error)"))
        }
    }
    
    func postData() async -> Result<Teams?, TeamsRequestError> {
        do {
            guard teamIsCompleted.teamCompleted else { return .failure(.invalidData) }
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            if let association, let league, let season, let sex, !teamName.isEmpty {
                let team = Teams(teamName: teamName, sex: sex, association: association, league: league, season: season, adminID: self.adminID)
                let createdTeam = try await teamsProvider.registerTeam(team)
                return .success(createdTeam)
            }
            return .failure(.invalidData)
        } catch let error as TeamsServiceError {
            return .failure(error.teamsRequestError)
        } catch {
            return .failure(TeamsRequestError.unexpected("\(error)"))
        }
    }
    
    func updateData() async -> Result<Void, TeamsRequestError> {
        do {
            guard teamIsCompleted.teamCompleted else { return .failure(.invalidData) }
            let teamsProvider = CloudServiceManager.shared.teamsProvider
            if let association, let league, let season, let sex, !teamName.isEmpty {
                let team = Teams(teamName: teamName, sex: sex, association: association, league: league, season: season, adminID: self.adminID)
                _ = try await teamsProvider.updateTeam(team)
                return .success(())
            }
            return .failure(.invalidData)
            
        } catch let error as TeamsServiceError {
            return .failure(error.teamsRequestError)
        } catch {
            return .failure(TeamsRequestError.unexpected("\(error)"))
        }
    }
    
    func resetTeam() {
        teamName = ""
    }
    
    func dismissSheet(type: InputType?) {
        switch type {
        case .association:
            if self.association == nil {
                self.association = Association.allCases[0]
            }
        case .league:
            if self.league == nil {
                self.league = League.allCases[0]
            }
        case .season:
            if self.season == nil {
                self.season = Season.allCases[0]
            }
        case .sex:
            if self.sex == nil {
                self.sex = Sex.allCases[0]
            }
        default:
            break
        }
    }
    
    func retrieveNewTeam() -> Teams? {
        if let association, let league, let season, let sex, !teamName.isEmpty {
            return Teams(teamName: teamName, sex: sex, association: association, league: league, season: season, adminID: self.adminID)
        }
        return nil
    }
}

