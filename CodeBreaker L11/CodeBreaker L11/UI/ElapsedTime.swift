//
//  ElapsedTime.swift
//  CodeBreaker
//

import SwiftUI

struct ElapsedTime: View {
    let startTime: Date
    let endTime: Date?
    
    var body: some View {
        if let endTime {
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
    }
}
//
//#Preview {
//    ElapsedTime()
//}

