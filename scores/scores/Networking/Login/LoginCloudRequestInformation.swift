import UIKit

// MARK: - LoginCloudRequestInformation
enum LoginCloudRequestInformation: CloudRequest {
    case signIn
}

// MARK: - baseURL
extension LoginCloudRequestInformation {
    var baseURL: URL {
        URL(string: "http://localhost:3000/api/auth")!
    }
}

// MARK: - URL
extension LoginCloudRequestInformation {
    var url: URL {
        return baseURL.appending(path: self.path)
    }
}

// MARK: - CloudOperation
extension LoginCloudRequestInformation {
    var operation: CloudOperation {
        switch self {
        case .signIn:           return .create
        }
    }
}

// MARK: - HTTP Headers
extension LoginCloudRequestInformation {
    var headers: [HTTPHeader]? {
        switch self {
        case .signIn:
            return [.contentType(mediaType: .applicationJson)]
        }
    }
}

extension LoginCloudRequestInformation {
    var path: String {
        switch self {
        case .signIn:           return "login"
        }
    }
}
