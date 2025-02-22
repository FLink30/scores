import Foundation

public enum CloudOperation: String {
    case create = "POST"
    case read = "GET"
    case update = "PUT"
    case delete = "DELETE"
    case modify = "PATCH"
    
    func callAsFunction() -> String {
        return self.rawValue
    }

    var httpMethod: String { return self.rawValue }
}
