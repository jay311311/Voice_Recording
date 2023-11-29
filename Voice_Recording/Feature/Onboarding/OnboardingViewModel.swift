//
//  OnboardingViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents:[OnboardingContent]
    
    init(onboardingContents: [OnboardingContent] = [
        .init(
            imageImage: "test_onboarding",
            title: "To-Do List",
            subTitle: "What you need to do anytime, anywhere at a glance"
        ),
        .init(
            imageImage: "test_onboarding",
            title: "Smart Memo",
            subTitle: "Write your memmo anywhere"
        ),
        .init(
            imageImage: "test_onboarding",
            title: "Voice Recording",
            subTitle: "Record your Voice memo"
        ),
        .init(
            imageImage: "test_onboarding",
            title: "Accurate timer",
            subTitle: "Check your time"
        )
    ]) {
        self.onboardingContents = onboardingContents
    }
}
