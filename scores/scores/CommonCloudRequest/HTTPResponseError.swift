import Foundation

public enum HTTPResponseError: Error, Equatable {
    case unauthorized
    case notFound
    case badRequest
    case unprocessableEntity
    case tooManyRequests
    case forbidden
    case timeout
    case unexpected(String)
    case gone
}
