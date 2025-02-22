import Foundation

extension URLRequest {
    mutating func applyHeader(_ header: HTTPHeader) {
        self.addValue(header.field, forHTTPHeaderField: header())
    }
    
    mutating func setHeader(_ header: HTTPHeader) {
        self.setValue(header.field, forHTTPHeaderField: header())
    }
    
    mutating func setHeader(_ value: String, field: String) {
        self.setValue(value, forHTTPHeaderField: field)
    }
}
