import Foundation

enum TokenHandlerError: Error {
    case ownershipViolation(String)
    case tokenRefreshFailed
    case tokenRetrievalError(String, Error)
    case errorOccurred(Error)
    
    case unexpectedError(String, Error)
}

protocol TokenHandlerDelegate: AnyObject {
    func processTokens(from carrier: TokenCarrier) throws
}

// https://www.donnywals.com/building-a-token-refresh-flow-with-async-await-and-swift-concurrency/
actor TokenHandler {
    
    // MARK: - Private Properties
    private var refreshTask: Task<Bool, Error>?
    private var cloudIdentityPersistenceService: CloudIdentityPersistencService
    
    // MARK: Weak Properties
    private weak var delegate: TokenHandlerDelegate?
    
    // MARK: - Init
    init(cloudIdentityPersistencService: CloudIdentityPersistencService,
         delegate: TokenHandlerDelegate) {
        self.cloudIdentityPersistenceService = cloudIdentityPersistencService
        self.delegate = delegate
    }
}

extension TokenHandler {
    func provideSessionToken() async throws -> CloudToken {
        if let refreshTask {
            let refreshResult: Bool
            do {
                refreshResult = try await refreshTask.value
            } catch {
                throw TokenHandlerError.errorOccurred(error)
            }
            
            if !refreshResult {
                throw TokenHandlerError.tokenRefreshFailed
            }
        }
        
        do {
            return try type(of: cloudIdentityPersistenceService).retrieveSessionToken()
        } catch let error as KeychainError {
            throw TokenHandlerError.tokenRetrievalError("while retrieving session token", error)
        } catch {
            throw TokenHandlerError.unexpectedError("while retrieving session token", error)
        }
    }
}

extension TokenHandler {
    
}
