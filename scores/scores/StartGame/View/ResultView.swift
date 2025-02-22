import Foundation
import SwiftUI

struct ResultView: View {
    @Binding var counter: Int
    @Binding var goalsHome: Int
    @Binding var goalsOpponent: Int
    
    var homeTeamName: String
    var opponentTeamName: String
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(.background.secondary)
                        
                        SystemImage.person()
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: 60, maxHeight: 60)
                    
                    Text(homeTeamName)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 100)
                
                Spacer()
                
                VStack {
                    VStack(alignment: .trailing, spacing: 0, content: {
                        Button(action: {
                            toggleButton()
                        }, label: {
                            
                            HStack(alignment: .top, spacing: 0, content: {
                                
                                SystemImage.figureHandball()
                                    .font(.system(size: 20))
                                
                                SystemImage.plus()
                                    .font(.system(size: 15))
                            })
                        })
                        
                        Text("\(goalsHome) : \(goalsOpponent)")
                            .font(.system(size: 30))
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    Text("\(counter.formattedTime)")
                        .font(.system(size: 40))
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    ZStack(alignment: .bottom, content: {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(.background.secondary)
                            
                            SystemImage.person()
                                .font(.system(size: 30))
                                .frame(maxHeight: .infinity, alignment: .center)
                            
                        }
                        .frame(maxWidth: 60, maxHeight: 60)
                    })
                    Text(opponentTeamName)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 100)
            }
            
        }
    }
    
    private func toggleButton() {
        goalsOpponent += 1
    }
}

#Preview {
    @State var counter: Int = 0
    @State var goalsHome: Int = 0
    @State var goalsOpponent: Int = 0
    return ResultView(counter: $counter, goalsHome: $goalsHome, goalsOpponent: $goalsOpponent, homeTeamName: "HomeTeam", opponentTeamName: "OpponentTeam")
}
