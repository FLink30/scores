//
//  RegistrationRequestBody.swift
//  scores
//
//  Created by Tabea Privat on 30.12.23.
//

import Foundation

struct RegistrationRequestBody: Codable {
    let mail: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case mail = "mail"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
