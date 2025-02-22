import Foundation

enum GamesParameter {
    case id(String)
    case page(Int)
    case pageSize(Int)
    case teamName(String)
    
    var asQueryItem: URLQueryItem {
        switch self {
        case .id(let string):
            return URLQueryItem(name: "id", value: string)
        case .page(let int):
            return URLQueryItem(name: "page", value: "\(int)")
        case .pageSize(let int):
            return URLQueryItem(name: "pageSize", value: "\(int)")
        case .teamName(let string):
            return URLQueryItem(name: "team_name", value: string)
        }
    }
}
