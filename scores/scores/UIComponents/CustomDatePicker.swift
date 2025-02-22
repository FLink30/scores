//
//  DatePicker.swift
//  scores
//
//  Created by Franziska Link on 16.01.24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2024, month: 1, day: 1)
        let endComponents = DateComponents(year: 2025, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    
    
    var body: some View {
        DatePicker(
            "Zeitpunkt",
            selection: $date,
            in: dateRange,
            displayedComponents: [.date, .hourAndMinute]
        )
        .padding()
        
    }
}
//
//#Preview {
//    CustomDatePicker(createGameViewModel: CreateGameViewModel(createPlayerViewModel: CreatePlayerViewModel()))
//}
