import Foundation
@testable import scores

enum Mode {
    case success(any Codable)
    case successWithBrokenJSON
    case badRequest
    case unauthorized
    case simulateTokenRefresh(any Codable)
    case simulateTokenRefreshFails
    case simulateParallelRequestWhileTokenRefresh(CodableCounter)
}

class SessionMock: Session {

    private let mode: Mode
    private var tokenRefreshCounter: Int = 0

    init(mode: Mode) {
        self.mode = mode
    }

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        switch mode {
        case .success(let codable):
            guard let data = codable.asData else {
                /// NO HANDLING IN FATAL ERROR: MOC
                fatalError("Could not convert codable as data")
            }
            return (data, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
        case .successWithBrokenJSON:
            let string = "{Broken: JSON: TEST}"
            guard let data = string.data(using: .utf8) else {
                /// NO HANDLING IN FATAL ERROR: MOC
                fatalError("Could not convert codable as data")
            }
            return (data, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
        case .badRequest:
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400))
        case .unauthorized:
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 401))
        case .simulateTokenRefresh(let response):
            return handleTokenRefreshSimulation(for: request, with: response)
        case .simulateTokenRefreshFails:
            return handleTokenRefreshFailsSimulation(for: request)
        case .simulateParallelRequestWhileTokenRefresh(let response):
            return await handleParallelExpiredTokenCalls(for: request, with: response)
        }
    }
}

extension SessionMock {
    private func handleTokenRefreshSimulation(for request: URLRequest, with response: Codable) -> (Data, URLResponse) {
        guard let url = request.url else { return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400)) }
        
        switch url.lastPathComponent {
        case "authenticationRequired":
            if tokenRefreshCounter == 0 {
                return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 401))
            } else {
                guard let data = response.asData else {
                    /// NO HANDLING IN FATAL ERROR: MOC
                    fatalError("Could not convert codable as data")
                }
                return (data, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
            }
        case "refresh":
            let token = CloudIdentityRaw.mock
            
            /// this is a mock
            // swiftlint:disable:next force_try
            let tokenData = try! JSONEncoder().encode(token)
            tokenRefreshCounter += 1
            return (tokenData, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
        default:
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400))
        }
    }
    
    private func handleTokenRefreshFailsSimulation(for request: URLRequest) -> (Data, URLResponse) {
        guard let url = request.url else { return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400)) }
        
        switch url.lastPathComponent {
        case "authenticationRequired":
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 401))
        case "refresh":
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 401))
        default:
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400))
        }
    }
    
    private func handleParallelExpiredTokenCalls(for request: URLRequest, with response: CodableCounter) async -> (Data, URLResponse) {
        guard let url = request.url else { return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400)) }
        
        switch url.lastPathComponent {
        case "authenticationRequired":
            if tokenRefreshCounter == 0 {
                return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 401))
            } else {
                let newResponse = CodableCounter(count: response.count + tokenRefreshCounter)
                guard let data = newResponse.asData else {
                    /// NO HANDLING IN FATAL ERROR: MOC
                    fatalError("Could not convert codable as data")
                }
                return (data, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
            }
        case "refresh":
            /// give to so we can have multiple request which need a token
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
            } catch {
                return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400))
            }
            
            let token = CloudIdentityRaw.mock
            
            /// this is a mock
            // swiftlint:disable:next force_try
            let tokenData = try! JSONEncoder().encode(token)
            tokenRefreshCounter += 1
            return (tokenData, HTTPURLResponse.generateMockHTTPURLResponse(with: 200))
        default:
            return (Data(), HTTPURLResponse.generateMockHTTPURLResponse(with: 400))
        }
    }
}

struct FakeCodable: Codable {
    let text: String
}

struct CodableCounter: Codable {
    let count: Int
}

class FakeCloudRequest: CloudRequest {
    
    init(url: URL) {
        self.url = url
    }

    var url: URL
    var path: String = ""
    var operation: CloudOperation = .read
    var headers: [HTTPHeader]?
    var numberOfRetries: Int = 0
}

struct FakeBody: Codable {
    let title: String
    let bodyText: String
}

class FakeAuthenticatingCloudRequest: CloudRequest {
    
    init(url: URL) {
        self.url = url.appendingPathComponent("authenticationRequired")
    }

    var url: URL
    var path: String = ""
    var operation: CloudOperation = .read
    var headers: [HTTPHeader]? = [.authorization()]
    var numberOfRetries: Int = 0
}
