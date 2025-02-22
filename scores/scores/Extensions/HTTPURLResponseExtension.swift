import Foundation

extension HTTPURLResponse {
    static func generateMockHTTPURLResponse(with statusCode: Int, urlString: String = "https://apple.com") -> URLResponse {
        guard let url = URL(string: urlString) else {
            fatalError("Could not create url form \(urlString)")
        }
        guard let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
            fatalError("Failed to create HTTPURLResponse")
        }
        return response
    }
}
