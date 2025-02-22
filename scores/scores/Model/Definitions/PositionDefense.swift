//
//  PositionDefense.swift
//  scores
//
//  Created by Franziska Link on 22.12.23.
//

import Foundation

enum PositionDefense: String, CaseIterable, PickerData  {
    case torwart
    case nochnePosition
    
    func callAsFunction() -> String {
        self.rawValue.capitalized
    }
}
