//
//  Sex.swift
//  scores
//
//  Created by Franziska Link on 09.12.23.
//

import Foundation
// CaseIterable: wir können über alle Cases iterieren
enum Sex: String, CaseIterable, Equatable, Hashable, PickerData, Codable {
    case female
    case divers
    case male
    
    func callAsFunction() -> String {
        switch self {
        case .female:
            return "Frauen"
        case .divers:
            return "Divers"
        case .male:
            return "Männer"
        }
    }
    
    var asBackendString: String {
        switch self {
        case .female:
            return "female"
        case .divers:
            return "divers"
        case .male:
            return "male"
        }
    }
}
