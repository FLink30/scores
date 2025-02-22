//
//  League.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import Foundation
enum League: String, CaseIterable, Equatable, PickerData, Codable {
    case oberliga = "Oberliga"
    case verbandsliga = "Verbandsliga"
    case landesliga = "Landesliga"
    case bezirksoberliga = "Bezirksoberliga"
    case bezirksliga = "Bezirksliga"
    case bezirksklasse = "Bezirksklasse"
    case kreisliga = "Kreisliga"
    case kreisklasse = "Kreisklasse"
    case unknown = "Unknown"
    
    func callAsFunction() -> String {
        self.rawValue
    }
}

protocol PickerData {
    func callAsFunction() -> String
}
