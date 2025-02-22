import Foundation
import OSLog

public protocol CloudIdentityManagementService: AnyObject {
    var onLoginRequired: (() -> Void)? { get set }
}

protocol AuthenticationService: CloudIdentityManagementService {
    func processTokens(from carrier: TokenCarrier) throws
    func provideSessionToken() async throws -> CloudToken
}

public enum AuthenticationServiceError: Error {
    case decodingError(TokenDecoderError)
    case persistenceError(KeychainError)
    case tokenRetrievalError(String, KeychainError)
    case tokenRenewalError(String)
    
    case unexpectedError(String, Error)
}

final class AuthenticationHandler: AuthenticationService, TokenHandlerDelegate {
    
    // MARK: - Private Properties
    private let cloudIdentityPersistenceService: CloudIdentityPersistencService
    private var tokenHandler: TokenHandler!
    
    // MARK: - Accessible Properties
    var onLoginRequired: (() -> Void)?
    
    // MARK: - Init
    init(cloudIdentityPersistencService: CloudIdentityPersistencService) {
        self.cloudIdentityPersistenceService = cloudIdentityPersistencService
        
        self.tokenHandler = TokenHandler(cloudIdentityPersistencService: cloudIdentityPersistencService,
                                         delegate: self)
    }
}

// MARK: - Accessible Methods
extension AuthenticationHandler {
    func processTokens(from carrier: TokenCarrier) throws {
        let cloudIdentity: CloudIdentity
        do {
            cloudIdentity = try TokenDecoder.makeCloudIdentity(from: carrier)
        } catch let error as TokenDecoderError {
            throw AuthenticationServiceError.decodingError(error)
        } catch {
            throw AuthenticationServiceError.unexpectedError("while decoding token", error)
        }
        
        do {
            try type(of: cloudIdentityPersistenceService).persist(cloudIdentity)
        } catch let error as KeychainError {
            throw AuthenticationServiceError.persistenceError(error)
        } catch {
           throw AuthenticationServiceError.unexpectedError("while persisting token", error)
       }
    }
    
    func provideSessionToken() async throws -> CloudToken {
        do {
            return try await tokenHandler.provideSessionToken()
        } catch let error as KeychainError {
            throw AuthenticationServiceError.tokenRetrievalError("while retrieving session token", error)
        } catch {
            throw AuthenticationServiceError.unexpectedError("while retrieving session token", error)
        }
    }
}

// MARK: - Logger
extension AuthenticationHandler {
    private static var logger: Logger {
        Logger.authenticationHandler
    }
}
