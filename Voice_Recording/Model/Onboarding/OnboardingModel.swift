//
//  OnboardingModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import Foundation

struct OnboardingModel: Hashable {
    var imageFileName: String
    var title: String
    var subTitle: String
    
    init(imageFileName: String,
         title: String,
         subTitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
