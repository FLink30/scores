//
//  StartGameView.swift
//  scores
//
//  Created by Franziska Link on 10.01.24.
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var startViewModel: StartGameViewModel
    
    @State private var counter = 0
    @State private var isTimerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTime: String {
        let minutes = counter / 60
        let seconds = counter % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var buttonText: String {
        if isTimerRunning {
            return "Pause"
        } else {
            return "Start"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("\(formattedTime)")
                        .font(.system(size: 60))
                        .padding()
                    
                    Divider()
                    
                    Button(action: {
                        
                    }, label: {
                        SystemImage.playFilled()
                    })
                    
                    Divider()
                    CustomButton(type: .filled, title: buttonText, disabled: false, action: {
                        toggleTimer()
                    })
                    
                    CustomButton(type: .filled, title: "Stop", disabled: !isTimerRunning, action: {
                        stopTimer()
                    })
                }
                .onReceive(timer) { _ in
                    // Aktionen, die bei jedem Timer-Tick ausgeführt werden sollen
                    if isTimerRunning {
                        counter += 1
                    }
                    
                }
                
                
                
            }.navigationTitle("")
            
        }
    }
    
    private func toggleTimer() {
        isTimerRunning.toggle()
    }
    
    private func stopTimer() {
        isTimerRunning = false
        //        counter = 0
    }
}

#Preview {
    let game = Game(homeTeam: UUID(),
                    opponentTeam: UUID(),
                    location: "Mannheim",
                    dateTime: DateComponents(year: 2024, month: 11, day: 10, hour: 20, minute: 00, second: 00),
                    goalsHomeTeam: 2,
                    goalsOpponent: 1)
    
    return StartGameView(startViewModel: StartGameViewModel(game: game))
}
