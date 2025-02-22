//
//  Association.swift
//  scores
//
//  Created by Franziska Link on 14.12.23.
//

import Foundation
enum Association: String, CaseIterable, Equatable, PickerData, Hashable, Codable {
    case niedersachsenBremen = "Handballverband Niedersachsen-Bremen"
    case sachsenAnhalt = "Handball-Verband Sachsen-Anhalt"
    case berlin = "Handball-Verband Berlin"
    case brandenburg = "Handball-Verband Brandenburg"
    case hamburg = "Hamburger Handball-Verband"
    case mecklenburgVorpommern = "Handballverband Mecklenburg-Vorpommern"
    case schleswifHolstein = "Handballverband Schleswig-Holstein"
    case badisch = "Badischer Handball-Verband"
    case bayrisch = "Bayerischer Handball-Verband"
    case sachsen = "Handball-Verband Sachsen"
    case southBaden = "Südbadischer Handball-Verband"
    case wurttemberg = "Handballverband Württemberg"
    case hessen = "Hessischer Handballverband"
    case pfalz = "Pfälzer Handball-Verband"
    case rheinhessen = "Handball-Verband Rheinhessen"
    case saar = "Handball-Verband Saar"
    case thuringen = "Thüringer Handball-Verband"
    case rheinland = "Handball-Verband Rheinland"
    case nordrhein = "Handballverband Nordrhein"
    case westfalen = "Handball-Verband Westfalen"
    case unknown = "Unknown"
    
    func callAsFunction() -> String {
        self.rawValue
    }
    
    var asBackendString: String {
        if let encodedValue = self().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return encodedValue
        } else {
            return self()
        }
    }
}
