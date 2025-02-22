//
//  PositionAttack.swift
//  scores
//
//  Created by Franziska Link on 22.12.23.
//

import Foundation

enum PositionAttack: String, CaseIterable, PickerData, Codable {
    case torhüter
    case kreisläufer
    case linksAusen
    case rechtsAusen
    case rückraumLinks
    case rückraumRechts
    case rückraumMitte

    func callAsFunction() -> String {
        switch self {
        case .torhüter:
            return "Torhüter"
        case .kreisläufer:
            return "Kreisläufer"
        case .linksAusen:
            return "Linksaußen"
        case .rechtsAusen:
            return "Rechtsaußen"
        case .rückraumLinks:
            return "Rückraum Links"
        case .rückraumRechts:
            return "Rückraum Rechts"
        case .rückraumMitte:
            return "Rückraum Mitte"
        }
    }
}
