//
//  ProfileResponseBody.swift
//  scores
//
//  Created by Tabea Privat on 06.01.24.
//

import Foundation

struct ProfileResponseBody: Codable {
    let userID: String
    let firstName: String
    let lastName: String
    let mail: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case mail = "mail"
    }
}

struct Profile {
    let userID: UUID
    let firstName: String
    let lastName: String
    let mail: String
    
    init(userID: UUID, firstName: String, lastName: String, mail: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.mail = mail
    }
    
    init?(body: ProfileResponseBody) {
        guard let uuid = UUID(uuidString: body.userID) else { return nil }
        
        self.userID = uuid
        self.firstName = body.firstName
        self.lastName = body.lastName
        self.mail = body.mail
    }
}
