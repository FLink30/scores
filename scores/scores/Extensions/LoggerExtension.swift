import Foundation
import OSLog

extension Logger {
    private enum LogCategory: String {
        case cloudService = "CloudService"
        case authenticationManager = "Manager.Authentication"
        case authenticationHandler = "Handler.Authentication"
        
        func callAsFunction() -> String {
            self.rawValue
        }
    }

    private static var bundleIdentifier: String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("No bundle identifier was found")
        }
        return bundleIdentifier
    }

    static let cloudService = Logger(subsystem: bundleIdentifier,
                                    category: LogCategory.cloudService())
    static let authenticationManager = Logger(subsystem: bundleIdentifier,
                                    category: LogCategory.authenticationManager())
    static let authenticationHandler = Logger(subsystem: bundleIdentifier,
                                    category: LogCategory.authenticationHandler())
}
