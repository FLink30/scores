import Foundation
import OSLog

// MARK: - KeychainError
public enum KeychainError: Error {
    /// Attempted read for an item that does not exist.
    case itemNotFound
    
    /// Attempted save to override an existing item.
    case duplicateItem
    
    /// A read of an item in any format other than Data
    case invalidItemFormat
    
    /// Any operation result status than errSecSuccess
    case unexpectedStatus(OSStatus)
}

// MARK: - CloudSessionHandling
public protocol CloudSessionHandling {
    static var isCloudIdentityAvailable: Bool { get }
    
    static func removeCloudIdentity() throws
}

// MARK: - CloudIdentityPersistencService
protocol CloudIdentityPersistencService {
    static func persist(_ cloudIdentity: CloudIdentity) throws
    static func removeCloudIdentity() throws
    
    static func retrieveSessionToken() throws -> CloudToken
}

// MARK: - AuthenticationManager
public class AuthenticationManager {
    
    // MARK: - Private Properties
    private static var account: String {
        "AuthenticationPersistable"
    }
}

// MARK: - CloudSessionHandling Implementation
extension AuthenticationManager: CloudSessionHandling {
    public static var isCloudIdentityAvailable: Bool {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: account as AnyObject,
                                          kSecMatchLimit as String: kSecMatchLimitOne,
                                          kSecReturnData as String: kCFBooleanTrue]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )

        guard status != errSecItemNotFound,
                status == errSecSuccess,
                itemCopy is Data else {
            return false
        }
        
        return true
    }
    
    static public func removeCloudIdentity() throws {
        try deleteData()
    }
}

// MARK: - CloudIdentityPersistencService Implementation
extension AuthenticationManager: CloudIdentityPersistencService {
    static func persist(_ cloudIdentity: CloudIdentity) throws {
        var authenticationItems: [AuthenticationPersistable] = []
        
        do {
            authenticationItems = try retrieveData()
        } catch {
            logger.info("Could not read Data from Keychain")
        }
        
        let persistable = AuthenticationPersistable(type: .idpToken, token: cloudIdentity)
        
        guard !authenticationItems.contains(persistable) else {
            return
        }
        
        authenticationItems = [persistable]
        let encoder = JSONEncoder()
        let data = try encoder.encode(authenticationItems)

        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: account as AnyObject,
                                          kSecValueData as String: data as AnyObject]
        do {
            try deleteData()
        } catch {
            logger.info("Could not delete Data from Keychain")
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func retrieveSessionToken() throws -> CloudToken {
        let authenticationItems: [AuthenticationPersistable]
        
        do {
            authenticationItems = try retrieveData()
        } catch {
            logger.info("Could not read Data from Keychain")
            throw KeychainError.itemNotFound
        }
        
        guard let firstItem = authenticationItems.first else {
            throw KeychainError.itemNotFound
        }
        
        return firstItem.token.sessionToken
    }
}

// MARK: - Private Methods
extension AuthenticationManager {
    private static func deleteData() throws {
        let query: [String: AnyObject] = [kSecAttrAccount as String: account as AnyObject,
                                          kSecClass as String: kSecClassGenericPassword]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    private static func retrieveData() throws -> [AuthenticationPersistable] {
        let decoder = JSONDecoder()

        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: account as AnyObject,
                                          kSecMatchLimit as String: kSecMatchLimitOne,
                                          kSecReturnData as String: kCFBooleanTrue]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        let authenticationItems = try decoder.decode([AuthenticationPersistable].self, from: data)
        
        return authenticationItems
    }
}

// MARK: - Logger
extension AuthenticationManager {
    private static var logger: Logger {
        Logger.authenticationManager
    }
}
