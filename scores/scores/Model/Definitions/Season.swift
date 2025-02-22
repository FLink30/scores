//
//  Season.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import Foundation
enum Season: String, CaseIterable, Equatable, PickerData, Codable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"
    case i = "I"
    case j = "J"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case unknown = "Unknown"

    func callAsFunction() -> String {
        self.rawValue
    }
}
