//
//  OnboardingViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingModel:[OnboardingModel]
    
    init(onboardingModel: [OnboardingModel] = [
        .init(
            imageFileName: "test_onboarding",
            title: "To-Do List",
            subTitle: "What you need to do anytime, anywhere"
        ),
        .init(
            imageFileName: "test_onboarding",
            title: "Smart Memo",
            subTitle: "Write your memmo anywhere"
        ),
        .init(
            imageFileName: "test_onboarding",
            title: "Voice Recording",
            subTitle: "Record your Voice memo"
        ),
        .init(
            imageFileName: "test_onboarding",
            title: "Accurate timer",
            subTitle: "Check your time"
        )
    ]) {
        self.onboardingModel = onboardingModel
    }
}
