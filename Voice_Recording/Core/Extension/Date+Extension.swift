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
        formatter.locale = Locale(identifier: "en-CA")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
    
    var formattedDay: String {
        let now = Date()
        let calendar = Calendar.current
        let nowStartOfDay = calendar.startOfDay(for: now)
        let dateStartOfDay = calendar.startOfDay(for: self)
        
        let differentOfDay = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day
        
        if differentOfDay == 0 {
            return "today"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en-CA")
            formatter.dateFormat = "E, MMMM dd"
            return formatter.string(from: self)
        }
    }
}
