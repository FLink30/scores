//
//  LoginCloudRequestHandler.swift
//  scores
//
//  Created by Tabea Privat on 28.12.23.
//

import Foundation

// MARK: - LoginCloudRequestHandler
final class LoginCloudRequestHandler: CloudRequestHandler {
    
    // MARK: - Accessible Properties
    private(set) var cloudRequestExecuter: CloudRequestExecuter
    
    // MARK: - Init
    init() {
        self.cloudRequestExecuter = CloudServiceManager.shared.commonRequestExecuter
    }
    
    init(cloudRequestExecuter: CloudRequestExecuter) {
        self.cloudRequestExecuter = cloudRequestExecuter
    }
}

// MARK: - RemoteSignInHandler implementation
extension LoginCloudRequestHandler: RemoteLoginHandler {
    func signIn(email: String, password: String) async throws -> CloudIdentityRaw {
        let cloudRequest = LoginCloudRequestInformation.signIn
        let credentials = UserCredentials(mail: email, password: password)
        let token: CloudIdentityRaw = try await cloudRequestExecuter.execute(cloudRequest, requestBody: credentials, queryItems: nil)
        return token
    }

 }
