import Foundation

// MARK: - Remote Token Validation Handler Protocol
public protocol RemoteTokenValidationHandler: AnyObject {
    func validateToken() async throws
}
