//
//  Response.swift
//  scores
//
//  Created by Tabea Privat on 05.01.24.
//

import Foundation

public struct Response: Codable {
    let statusCode: HTTPStatusCode
    let message: String
    
    init(statusCode: Int, message: String) {
        self.message = message
        self.statusCode = HTTPStatusCode(rawValue: statusCode) ?? .ok
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
    }
    
}
