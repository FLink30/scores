//
//  User.swift
//  scores
//
//  Created by Franziska Link on 08.12.23.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    
}
extension User {
    static func createUser() -> User {
            return User(id: UUID(),
                        firstName: "Max",
                        lastName: "Müller",
                        email: "MaxMüller@freenet.de")
        }
    
    static func createUserEmpty() -> User {
            return User(id: UUID(),
                        firstName: "",
                        lastName: "",
                        email: "")
        }
        
}
