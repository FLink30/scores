import XCTest
@testable import scores

final class RegistrationRequestTest: XCTestCase {

    func testRegistrationSucceeds() async throws {
        let cloudIdentityRaw: CloudIdentityRaw = CloudIdentityRaw.mock
        let session = SessionMock(mode: .success(cloudIdentityRaw))
        
        let commonRequestExecuter = CommonCloudRequestExecuter(session: session)
        let registrationCloudRequestHandler = RegistrationCloudRequestHandler(cloudRequestExecuter: commonRequestExecuter)
        let registrationProvider = RegistrationProvider(remoteRegistrationHandler: registrationCloudRequestHandler)
        var occuredError: Error?
        var response: UUID?
        
        do {
            response = try await registrationProvider.register(email: "test@test.com",
                                                               password: "12345678",
                                                               firstName: "Max",
                                                               lastName: "Mustermann")
        } catch {
            occuredError = error
        }
        
        XCTAssertNil(occuredError)
        XCTAssertNotNil(response)
    }
    
    func testRegistrationFailed() async throws {
        let session = SessionMock(mode: .badRequest)
        
        let commonRequestExecuter = CommonCloudRequestExecuter(session: session)
        let registrationCloudRequestHandler = RegistrationCloudRequestHandler(cloudRequestExecuter: commonRequestExecuter)
        let registrationProvider = RegistrationProvider(remoteRegistrationHandler: registrationCloudRequestHandler)
        var occuredError: Error?
        var response: UUID?
        
        do {
            response = try await registrationProvider.register(email: "test@test.com",
                                                               password: "12345678",
                                                               firstName: "Max",
                                                               lastName: "Mustermann")
        } catch {
            occuredError = error
        }
        
        XCTAssertNotNil(occuredError)
        
        XCTAssertNil(response)
    }
}
