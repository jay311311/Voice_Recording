//
//  MemoModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/20.
//

import Foundation


struct MemoModel: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID()
    
    var convertedDate: String {
        return "\(date.formattedDay) - \(date.formattedTime)"
    }
    
    
}
