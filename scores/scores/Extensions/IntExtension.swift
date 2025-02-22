//
//  IntExtension.swift
//  scores
//
//  Created by Tabea Privat on 26.01.24.
//

import Foundation

extension Int {
    var formattedTime: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
