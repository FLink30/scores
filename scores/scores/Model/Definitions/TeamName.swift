//
//  Team.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import Foundation

enum TeamName: String, CaseIterable, PickerData {
    case team1
    case team2
    case team3
    
    func callAsFunction() -> String {
        self.rawValue.capitalized
    }
}
