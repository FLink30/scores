import UIKit
import Foundation

// MARK: - RegistrationCloudRequestInformation
enum RegistrationCloudRequestInformation: CloudRequest {
    case register
}

// MARK: - baseURL
extension RegistrationCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api/auth")!
    }
}

// MARK: - URL
extension RegistrationCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension RegistrationCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .register:           return .create
        }
    }
}

// MARK: - HTTP Headers
extension RegistrationCloudRequestInformation {
    var headers: [HTTPHeader]? {
        switch self {
        case .register:
            return [.accept, .contentType(mediaType: .applicationJson)]
        }
    }
}

extension RegistrationCloudRequestInformation {
    var path: String {
        switch self {
        case .register:           return "register"
        }
    }
}
