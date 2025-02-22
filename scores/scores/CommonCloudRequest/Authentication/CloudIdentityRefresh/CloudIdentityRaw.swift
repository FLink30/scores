import Foundation

public struct CloudIdentityRaw: TokenCarrier, Codable {
    public let accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
