import Foundation
import SwiftUI
import Combine
import os

class AddPlayViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var playName: String = ""
    @Published var errorMessage: String?
    
    @Published var isInputValid: Bool = false
    
    
    init(){
        setUpObservation()
    }
    
    func setUpObservation () {
        $playName
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map { name in
                if name.isEmpty {
                    self.errorMessage = nil
                    return false
                } else {
                    if name.isValidName {
                        self.errorMessage = nil
                        return true
                    } else {
                        self.errorMessage = ErrorMessage.inputInvalid()
                        return false
                    }
                }
            }
            .assign(to: &$isInputValid)
    }

}
