import Foundation
import XCTest
@testable import scores

final class CommonRequestHandlerTests: XCTestCase {

    var url: URL {
        guard let url = URL(string: "https://apple.com") else {
            /// NO HANDLING IN FATAL ERROR: Test
            fatalError("Could not create url")
        }
        return url
    }

    func testGenerationOfURLRequestWithoutBodySucceeds() async throws {
        // GIVEN
        var occurredError: Error?
        var generatedUrlRequest: URLRequest?
        let fakeSession400 = SessionMock(mode: .badRequest)
        let cloudRequest = FakeCloudRequest(url: url)

        let commonRequestExecuter = CommonCloudRequestExecuter(session: fakeSession400)

        // WHEN
        let response = await commonRequestExecuter.generateURLRequest(for: cloudRequest)

        switch response {
        case .success(let urlRequest):
            generatedUrlRequest = urlRequest
        case .failure(let error):
            occurredError = error
        }

        // THEN
        XCTAssertNil(occurredError)
        XCTAssertNotNil(generatedUrlRequest)
    }

    func testGenerationOfURLRequestWithBodySucceeds() async {
        // GIVEN
        var occurredError: Error?
        var generatedUrlBody: Data?
        let fakeSession400 = SessionMock(mode: .badRequest)
        let cloudRequest = FakeCloudRequest(url: url)
        let commonRequestExecuter = CommonCloudRequestExecuter(session: fakeSession400)

        // WHEN
        let response = await commonRequestExecuter.generateURLRequest(
            for: cloudRequest,
            requestBody: FakeBody(title: "Title", bodyText: "Body Text")
        )

        switch response {
        case .success(let urlRequest):
            generatedUrlBody = urlRequest.httpBody
        case .failure(let error):
            occurredError = error
        }

        // THEN
        XCTAssertNil(occurredError)
        XCTAssertNotNil(generatedUrlBody)
    }

    func testIfCloudRequestHandlerReturnsCorrectError_WhenTheBackendSends400() async {
        // GIVEN
        let fakeSession400 = SessionMock(mode: .badRequest)
        let cloudRequest = FakeCloudRequest(url: url)
        let commonRequestExecuter = CommonCloudRequestExecuter(session: fakeSession400)
        var cloudError: HTTPResponseError = .unexpected("test")
        var undefinedError: Error?

        // WHEN
        let response = await commonRequestExecuter.generateURLRequest(for: cloudRequest)

        switch response {
        case .success:
            do {
                let _: String = try await commonRequestExecuter.execute(cloudRequest)
            } catch let error {
                guard let cloudServiceError = error as? CloudServiceError else {
                    undefinedError = error
                    return
                }
                if case .httpResponseError(let httpError, _) = cloudServiceError {
                    cloudError = httpError
                } else {
                    undefinedError = cloudServiceError
                }
            }
        case .failure(let error):
            undefinedError = error
        }

        // THEN
        XCTAssertNil(undefinedError)
        XCTAssertTrue(cloudError == .badRequest)
    }

    func testIfCloudRequestReturnsDecodeCodbale_WhenTheBackendSendsValidJSON() async {
        // GIVEN
        let fakeCodable = FakeCodable(text: "Sample Text")
        let fakeSession200 = SessionMock(mode: .success(fakeCodable))
        let cloudRequest = FakeCloudRequest(url: url)
        let commonRequestExecuter = CommonCloudRequestExecuter(session: fakeSession200)
        var undefinedError: Error?
        var requestedCodable: FakeCodable?

        // WHEN
        let response = await commonRequestExecuter.generateURLRequest(for: cloudRequest)
        switch response {
        case .success:

            do {
                let codableResponse: FakeCodable = try await commonRequestExecuter.execute(cloudRequest)
                requestedCodable = codableResponse
            } catch {
                undefinedError = error
            }
        case .failure(let error):
            undefinedError = error
        }

        // THEN
        XCTAssertNil(undefinedError)
        XCTAssertNotNil(requestedCodable)
        XCTAssertTrue(requestedCodable?.text == fakeCodable.text)
    }

    func testIfCloudRequestReturnsCorrectError_WhenTheBackendSendsBrokenJSON() async {
        // GIVEN
        let fakeSession200 = SessionMock(mode: .successWithBrokenJSON)
        let cloudRequest = FakeCloudRequest(url: url)
        let commonRequestExecuter = CommonCloudRequestExecuter(session: fakeSession200)
        var cloudError: CloudServiceError = .responseError
        var undefinedError: Error?

        // WHEN
        let response = await commonRequestExecuter.generateURLRequest(for: cloudRequest)
        switch response {
        case .success:

            do {
                let _: String = try await commonRequestExecuter.execute(cloudRequest)
            } catch {
                guard let error = error as? CloudServiceError else {
                    undefinedError = error
                    return
                }
                cloudError = error
            }
        case .failure(let error):
            undefinedError = error
        }

        // THEN
        XCTAssertNil(undefinedError)
        if case .jsonError = cloudError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error should be of type jsonErro")
        }
    }
}
