import XCTest
@testable import scores

final class CheckGameTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testLoginSucceeds() async throws {
        let cloudIdentityRaw: CloudIdentityRaw = CloudIdentityRaw.mock
        let session = SessionMock(mode: .success(cloudIdentityRaw))
        
        let commonRequestExecuter = CommonCloudRequestExecuter(session: session)
        let loginCloudRequestHandler = LoginCloudRequestHandler(cloudRequestExecuter: commonRequestExecuter)
        let loginProvider = LoginProvider(remoteLoginHandler: loginCloudRequestHandler)
        var occuredError: Error?
        var response: UUID?
        
        do {
            response = try await loginProvider.signIn(email: "test@test.com", password: "12345678")
        } catch {
            occuredError = error
        }
        
        XCTAssertNil(occuredError)
        XCTAssertNotNil(response)
    }
    
    func testLoginFailed() async throws {
        let session = SessionMock(mode: .badRequest)
        
        let commonRequestExecuter = CommonCloudRequestExecuter(session: session)
        let loginCloudRequestHandler = LoginCloudRequestHandler(cloudRequestExecuter: commonRequestExecuter)
        let loginProvider = LoginProvider(remoteLoginHandler: loginCloudRequestHandler)
        var occuredError: Error?
        var response: UUID?
        
        do {
            response = try await loginProvider.signIn(email: "test@test.com", password: "12345678")
        } catch {
            occuredError = error
        }
        
        XCTAssertNotNil(occuredError)
        
        XCTAssertNil(response)
    }
}
