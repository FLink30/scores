import Foundation

class MockCloudIdentityPersistenceService: CloudIdentityPersistencService {
    
    static func persist(_ cloudIdentity: CloudIdentity) throws { }
    
    static func removeCloudIdentity() throws { }
    
    static func retrieveSessionToken() throws -> CloudToken {
        CloudToken(raw: CloudIdentityRaw.sessionTokenString,
                   identifier: UUID().uuidString,
                   timeOfExpiration: -1)
    }
}
