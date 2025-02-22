import Foundation

extension CloudIdentityRaw {
    // swiftlint:disable line_length
    static var sessionTokenString: String {
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiY2Q1ZWQxOWMtMzExOC00YjBmLTg2YzEtMmY0MzRiMzQwODYxIiwibWFpbCI6InRhYmVhLnNjaHVsZXIrM0B3ZWIuZGUiLCJpYXQiOjE3MDQ0NTk0NTMsImV4cCI6MTcwNDQ2MzA1M30.h5Y4eJRbMTUAGPcI-3f5Cy4ZvprTNBF64Cn-lwxn_78"
    }
    // swiftlint:enable line_length
    
    static var mock: CloudIdentityRaw {
        CloudIdentityRaw(accessToken: sessionTokenString)
    }
}

extension CommonCloudRequestExecuter {
    static func makeExecuter(with session: Session) -> CommonCloudRequestExecuter {
        let executor = CommonCloudRequestExecuter(session: session)
        let authenticationService = AuthenticationHandler(cloudIdentityPersistencService: MockCloudIdentityPersistenceService())
        executor.register(authenticationService: authenticationService)
        
        return executor
    }
}
