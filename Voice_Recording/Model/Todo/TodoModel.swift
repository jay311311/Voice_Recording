//
//  TodoModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/02.
//

import Foundation

struct TodoModel: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        // ee - hh:mm 
        String("\(day.formattedDay) -  \(time.formattedTime)")
    }
}
