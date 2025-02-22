import Foundation

// MARK: - AuthenticationDataType
enum AuthenticationDataType: Codable {
    case idpToken
}

// MARK: - AuthenticationPersistable
struct AuthenticationPersistable: Codable {
    let type: AuthenticationDataType
    let token: CloudIdentity
}

// MARK: - Equatable
extension AuthenticationPersistable: Equatable {
    static func == (lhs: AuthenticationPersistable, rhs: AuthenticationPersistable) -> Bool {
        lhs.type == rhs.type && lhs.token == rhs.token
    }
}
