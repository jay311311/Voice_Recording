//
//  Double+Extension.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2024/01/20.
//

import Foundation

extension Double {
    var fomattedTimeInterval: String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
