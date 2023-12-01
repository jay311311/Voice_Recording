//
//  Date+Extension.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/01.
//

import Foundation

extension Date {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
    
    var formattedDay: String {
        var now = Date()
        var calendar = Calendar.current
        var nowStartOfDay = calendar.startOfDay(for: now)
        var dateStartOfDay = calendar.startOfDay(for: self)
        
        var differentOfDay = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day
        
        if differentOfDay == 0 {
            return "today"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "mm dd ee"
            return formatter.string(from: self)
        }
    }
}
