//
//  Size.swift
//  scores
//
//  Created by Franziska Link on 27.11.23.
//

import Foundation

enum Padding: CGFloat {
    case prettyPrettySmall = -48
    case prettySmall = -8
    case small = 8
    case medium = 16
    case large = 32
    case prettyLarge = 48
    case title = 352
    case menuWidth = 360
    case menuHeight = 74
 
    
    case prettyPrettyLarge = 72
    case iconPrettySmall = 56
    case iconSmall = 80
    case icon = 150
    case buttonHeight = 30
   
    
    func callAsFunction() -> CGFloat {
        self.rawValue
    }
}
