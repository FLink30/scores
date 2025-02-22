import UIKit

public enum HTTPHeader {
    case accept
    case contentType(mediaType: MediaType)
    case acceptLanguage(String? = nil)
    case authorization(String? = nil)
    case deviceIdentifier(String = UIDevice.current.identifierForVendor?.uuidString ?? "DeviceID")
    
    // Note:
    /// **acceptLanguage(String?=nil)** & **authorization(String?=nil)**
    /// For a CloudRequest, we just want to specify the headers used and
    /// we provide the header field when generating the URLRequest using HeaderResolver.
    
    var field: String {
        switch self {
        case .accept:
            return MediaType.applicationJson()
        case .contentType(let mediaType):
            return mediaType()
        case .acceptLanguage(let language):
            if let language = language {
                return language
            } else {
                return ""
            }
        case .authorization(let authorizationToken):
            if let authorizationToken = authorizationToken {
                return authorizationToken
            } else {
                return ""
            }
        case .deviceIdentifier(let vendorIdentifier):
            return vendorIdentifier
        }
    }
    
    func callAsFunction() -> String {
        switch self {
        case .accept:
            return "accept"
        case .contentType:
            return "Content-Type"
        case .acceptLanguage:
            return "Accept-Language"
        case .authorization:
            return "Authorization"
        case .deviceIdentifier:
            return "X-Device-ID"
        }
    }
}

public enum MediaType {
    case applicationJson
    case multipart(boundary: String)
    
    func callAsFunction() -> String {
        switch self {
        case .applicationJson:
            return "application/json"
        case .multipart(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
