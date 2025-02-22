import Foundation

enum CreateActionBackend {
    case goalThrow(CreateGoalThrowRequestBody?)
    case trf(CreateTRFRequestBody)
    case punishment(CreatePunishmentRequestBody)
    case exchange(CreateExchangePlayersRequestBody)
    
    var actionTypeBackend: ActionTypeBackend {
        switch self {
        case .goalThrow:
            return .goalThrow
        case .trf:
            return .trf
        case .punishment:
            return .punishment
        case .exchange:
            return .exchange
        }
    }
}

enum ActionTypeBackend {
    case goalThrow
    case trf
    case punishment
    case exchange
}
