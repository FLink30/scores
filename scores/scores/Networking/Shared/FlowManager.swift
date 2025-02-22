//
//  FlowManager.swift
//  scores
//
//  Created by Tabea Privat on 09.01.24.
//

import Foundation

enum FlowType {
    case login
    case menu
}

final class FlowManager: ObservableObject {
    static let shared = FlowManager()

    private(set) var currentFlowType: FlowType

    private init() {
        self.currentFlowType = .login
    }
    
    func didEndLogin() {
        self.currentFlowType = .menu
    }
}
