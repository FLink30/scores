import Foundation
enum UserDefaultsError: Error {
    case missingData
    case failedToEncodeData
    case failedToDecodeData
}

struct UserDefault<T: Codable> {

    func storeInUserDefaults(value: T, for key: UserDefaultsKeys) -> Result<Void, UserDefaultsError> {
        let defaults = UserDefaults.standard
        
        let encoder = JSONEncoder()
        let data: Data
        do {
            data = try encoder.encode(value)
            defaults.setValue(data, forKey: key())
            return .success(())
        } catch {
            return .failure(.failedToEncodeData)
        }
    }
    
    func retrieveValue(for key: UserDefaultsKeys) -> Result<T, UserDefaultsError> {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: key()) else {
            return .failure(.missingData)
        }
        
        let decoder = JSONDecoder()
        let value: T
        
        do {
            value = try decoder.decode(T.self, from: data)
            return .success(value)
        } catch {
            return .failure(.failedToDecodeData)
        }
    }
}

enum UserDefaultsKeys: String {
    case adminID
    case teamID
    
    func callAsFunction() -> String {
        self.rawValue
    }
}
