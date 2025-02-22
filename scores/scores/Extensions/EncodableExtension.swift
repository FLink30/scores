import Foundation

extension Encodable {
    var asJSON: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return nil }
        return json
    }

    var asPlainJSONArray: Any? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        return json
    }

    var asData: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}
