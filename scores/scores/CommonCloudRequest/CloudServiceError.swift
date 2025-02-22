import Foundation

public enum CloudServiceError: Error {
    case transportError(Error)
    case noInternetConnection(URLError)
    case jsonError(Error)
    case httpResponseError(HTTPResponseError, Response?)
    case invalidRequestBody
    case responseError
    case tokenHandlingError(String, AuthenticationServiceError)
    case headerResolvingError
    case unknown(Error)
    case emailConfirmationPending
}

extension URLError {
    var retryable: Bool {
        switch self.code {
        case .unknown, .timedOut, .cannotConnectToHost,
             .networkConnectionLost, .notConnectedToInternet, .badServerResponse,
             .cannotDecodeRawData, .cannotDecodeContentData, .cannotParseResponse,
             .downloadDecodingFailedMidStream, .downloadDecodingFailedToComplete:
            return true
        default:
            return false
        }
    }
}
