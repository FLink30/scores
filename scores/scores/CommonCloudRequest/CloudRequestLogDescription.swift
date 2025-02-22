import Foundation

enum CloudRequestLogDescription: CustomStringConvertible {
    case executing(CloudRequest, URLRequest)
    case receivedResponse(RepsonseType)
    
    enum RepsonseType {
        case success(CloudRequest, Data, HTTPStatusCode?)
        case failure(CloudRequest, HTTPStatusCode?)
    }
    
    var description: String {
        switch self {
        case .executing(let cloudRequest, let urlRequest):
            if let bodyData = urlRequest.httpBody,
               let bodyString = String(data: bodyData, encoding: .utf8) {
                return "Executing Cloud Request: \(cloudRequest.shortDescription) \(bodyString)"
            } else {
                return "Executing Cloud Request: \(cloudRequest.shortDescription)"
            }
            
        case .receivedResponse(let responseType):
            switch responseType {
            case .success(let cloudRequest, let data, let code):
                if let responseString = String(data: data, encoding: .utf8) {
                    let truncatedResponse = responseString.truncate(length: 1000)
                    return "Received Response: \(code?.rawValue ?? 0) \(cloudRequest.description) \(truncatedResponse)"
                } else {
                    return "Received Response: \(code?.rawValue ?? 0) \(cloudRequest.description) Response decode failed"
                }
            case .failure(let cloudRequest, let code):
                var message: String = ""
                switch code {
                case .unauthorized:        message = "Unauthorized"
                case .notFound:            message = "Not Found"
                case .badRequest:          message = "Bad Request"
                case .unprocessableEntity: message = "Unprocessable Entity"
                case .forbidden:           message = "Forbidden"
                default:                   message = "Error with Status Code"
                }
                
                return "Received response: \(code?.rawValue ?? 0) \(cloudRequest.description) \(message)"
            }
        }
    }
    
    var indentation: String {
        return "-   "
    }
    
    var end: String {
        return "-"
    }
}

extension String {
    func truncate(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
