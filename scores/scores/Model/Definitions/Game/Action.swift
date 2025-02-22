//
//  Action.swift
//  scores
//
//  Created by Tabea Privat on 25.01.24.
//

import Foundation
import SwiftUI

protocol Action {
    var id: UUID { get }
    var gameID: UUID { get }
    var time: Int { get set }
}

enum ActionType: Hashable, Identifiable {
    var id: UUID {
        switch self {
        case .goalThrow(let goalThrow):
            return goalThrow?.id ?? UUID()
        case .trf(let tRF):
            return tRF?.id ?? UUID()
        case .punishment(let punishment):
            return punishment?.id ?? UUID()
        case .exchange(let exchangePlayers):
            return exchangePlayers?.id ?? UUID()
        }
    }
    
    
    case goalThrow(GoalThrow?)
    case trf(TRF?)
    case punishment(Punishment?)
    case exchange(ExchangePlayers?)
    
    var asString: String {
        switch self {
        case .goalThrow:
            return "Torwurf"
        case .trf:
            return "TRF"
        case .punishment:
            return "Bestrafung"
        case .exchange:
            return "Auswechseln"
        }
    }
    
    static func == (lhs: ActionType, rhs: ActionType) -> Bool {
        switch (lhs, rhs) {
        case (.goalThrow(let goalThrowLhs), .goalThrow(let goalThrowRhs)):
            return goalThrowLhs == goalThrowRhs
        case (.trf(let trfLhs), .trf(let trfRhs)):
            return trfLhs == trfRhs
        case (.punishment(let punishmentLhs), .punishment(let punishmentRhs)):
            return punishmentLhs == punishmentRhs
        case (.exchange(let exchangeLhs), .exchange(let exchangeRhs)):
            return exchangeLhs == exchangeRhs
        default:
            return false
        }
    }
    
    var asImage: Image {
        switch self {
        case .goalThrow:
            SystemImage.figureHandball()
        case .trf:
            SystemImage.trf()
        case .punishment:
            SystemImage.card()
        case .exchange:
            SystemImage.auswechseln()
        }
    }
    
    var time: Int {
        switch self {
        case .goalThrow(let goalThrow):
            return goalThrow?.time ?? 0
        case .trf(let tRF):
            return tRF?.time ?? 0
        case .punishment(let punishment):
            return punishment?.time ?? 0
        case .exchange(let exchangePlayers):
            return exchangePlayers?.time ?? 0
        }
    }
}
