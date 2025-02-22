//
//  CloudServiceManager.swift
//  scores
//
//  Created by Tabea Privat on 09.01.24.
//

import Foundation

final class CloudServiceManager: ObservableObject {
    static let shared = CloudServiceManager()

    let session: URLSession
    let commonRequestExecuter: CommonCloudRequestExecuter

    private init() {
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        self.commonRequestExecuter = CommonCloudRequestExecuter(session: session)
    }
    
    init(sessionMock: Session) {
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        self.commonRequestExecuter = CommonCloudRequestExecuter(session: sessionMock)
    }
}

// MARK: - Login Provider
extension CloudServiceManager {
    var loginProvider: LoginProvider {
        let loginCloudRequestHandler = LoginCloudRequestHandler()
        return LoginProvider(remoteLoginHandler: loginCloudRequestHandler)
    }
}

// MARK: - Registration Provider
extension CloudServiceManager {
    var registrationProvider: RegistrationProvider {
        let registrationCloudRequestHandler = RegistrationCloudRequestHandler()
        return RegistrationProvider(remoteRegistrationHandler: registrationCloudRequestHandler)
    }
}

// MARK: - Profile Provider
extension CloudServiceManager {
    var profileProvider: ProfileProvider {
        let profileCloudRequestHandler = ProfileCloudRequestHandler()
        return ProfileProvider(remoteProfileHandler: profileCloudRequestHandler)
    }
}

// MARK: - Teams Provider
extension CloudServiceManager {
    var teamsProvider: TeamsProvider {
        let teamsCloudRequestHandler = TeamsCloudRequestHandler()
        return TeamsProvider(remoteTeamsHandler: teamsCloudRequestHandler)
    }
}

// MARK: - Games Provider
extension CloudServiceManager {
    var gamesProvider: GamesProvider {
        let gamesCloudRequestHandler = GamesCloudRequestHandler()
        return GamesProvider(remoteGamesHandler: gamesCloudRequestHandler)
    }
}

// MARK: - Players Provider
extension CloudServiceManager {
    var playersProvider: PlayersProvider {
        let playersCloudRequestHandler = PlayersCloudRequestHandler()
        return PlayersProvider(remotePlayersHandler: playersCloudRequestHandler)
    }
}

// MARK: - Playbook Provider
extension CloudServiceManager {
    var playbookProvider: PlaybookProvider {
        let playbookCloudRequestHandler = PlaybookCloudRequestHandler()
        return PlaybookProvider(remotePlaybookHandler: playbookCloudRequestHandler)
    }
}

// MARK: - Actions Provider
extension CloudServiceManager {
    var actionsProvider: ActionsProvider {
        let actionsCloudRequestHandler = ActionsCloudRequestHandler()
        return ActionsProvider(remoteActionsHandler: actionsCloudRequestHandler)
    }
}
