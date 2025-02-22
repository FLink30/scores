import Foundation

enum TeamsParameter {
    case association(String)
    case league(String)
    case series(String)
    
    var asQueryItem: URLQueryItem {
        switch self {
        case .association(let string):
            return URLQueryItem(name: "association", value: string)
        case .league(let string):
            return URLQueryItem(name: "league", value: string)
        case .series(let string):
            return URLQueryItem(name: "series", value: string)
        }
    }
}
