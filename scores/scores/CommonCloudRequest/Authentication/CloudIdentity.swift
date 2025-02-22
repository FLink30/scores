import Foundation

// MARK: - CloudToken
struct CloudToken: Codable {
    let raw: String
    let identifier: String
    let timeOfExpiration: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case timeOfExpiration = "exp"
        case identifier = "uuid"
        case raw
    }
}

// MARK: - Equatable
extension CloudToken: Equatable {
    static func == (lhs: CloudToken, rhs: CloudToken) -> Bool {
        lhs.raw == rhs.raw
    }
}

// MARK: - TokenDetails
struct TokenDetails: Codable {
    let identifier: String
    let mail: String
    let iat: TimeInterval
    let timeOfExpiration: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case timeOfExpiration = "exp"
        case identifier = "uuid"
        case mail = "mail"
        case iat = "iat"
    }
}

// MARK: - IDPToken
struct CloudIdentity: Codable {
    let sessionToken: CloudToken
}

// MARK: - Equatable
extension CloudIdentity: Equatable {
    static func == (lhs: CloudIdentity, rhs: CloudIdentity) -> Bool {
        lhs.sessionToken == rhs.sessionToken
    }
}
