//
//  Image.swift
//  scores
//
//  Created by Tabea Privat on 12.01.24.
//

import Foundation
import SwiftUI

enum SystemImage: String {
    
    case playFilled = "play.fill"
    case pauseFilled = "pause.fill"
    case stopFilled = "stop.fill"
    case chevronRight = "chevron.right"
    case chevronLeft = "chevron.left"
    case figureHandball = "figure.handball"
    case trf = "exclamationmark"
    case card = "rectangle.portrait.fill"
    case auswechseln = "arrow.left.arrow.right"
    case handball = "balloon"
    case xmark = "xmark"
    case checkmark = "checkmark"
    case plus = "plus"
    case person = "person.fill"
    case twoMinutes = "hand.tap.2"
    
    
    func callAsFunction() -> Image {
        Image(systemName: self.rawValue)
    }
    
    func playPause(isPlaying: Bool) -> Image {
        if isPlaying {
            return SystemImage.pauseFilled()
        } else {
            return SystemImage.playFilled()
        }
    }
}
