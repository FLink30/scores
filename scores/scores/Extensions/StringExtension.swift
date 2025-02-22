//
//  StringExtension.swift
//  scores
//
//  Created by Tabea Privat on 02.01.24.
//

import Foundation

extension String {
    func localized(comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

extension String {
    var isValidEmailAddress: Bool {
        let emailValidationRegex = "^[a-zA-Z0-9_+&*\\-]+(?:\\.[a-zA-Z0-9_+&*\\-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,15}$"
        
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        
        return emailValidationPredicate.evaluate(with: self)
    }
    
    var isValidName: Bool {
        let nameRegex = "^[a-zA-ZäöüÄÖÜß]+(([',. -][a-zA-ZäöüÄÖÜß ])?[a-zA-ZäöüÄÖÜß]*)*$"

        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let minLength = 8

        guard self.count >= minLength else {
            return false
        }
        return true
//        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
//        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        return passwordPredicate.evaluate(with: self)
    }
    
    var containsOnlyDigits: Bool {
        let characterSet = CharacterSet.decimalDigits
        return self.rangeOfCharacter(from: characterSet.inverted) == nil
    }

}

extension String {
    var asSex: Sex {
        if self == "male" {
            return .male
        } else if self == "female" {
            return .female
        } else {
            return .divers
        }
    }
    
    var asAssociation: Association {
        for association in Association.allCases {
            if self == association() {
                return association
            }
        }
        return .unknown
    }
    
    var asLeague: League {
        for league in League.allCases {
            if self == league() {
                return league
            }
        }
        return .unknown
    }
    
    var asSeason: Season {
        for season in Season.allCases {
            if self == season() {
                return season
            }
        }
        return .unknown
    }
    
    var asPosition: PositionAttack {
        for position in PositionAttack.allCases {
            if self == position() {
                return position
            }
        }
        return .torhüter
    }
    
    var asPunishmentType: PunishmentType? {
        for type in PunishmentType.allCases {
            if self == type.asBackendString {
                return type
            }
        }
        return nil
    }
}

extension String {
    var asBackendDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: self) {
            return date
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            return dateFormatter.date(from: self)
        }
    }
}
