//
//  OnboardingContent.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import Foundation

struct OnboardingContent {
    var imageImage: String
    var title: String
    var subTitle: String
    
    init(imageImage: String,
         title: String,
         subTitle: String) {
        self.imageImage = imageImage
        self.title = title
        self.subTitle = subTitle
    }
}
