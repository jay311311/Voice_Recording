//
//  OnboardingView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        // TODO: - Need to implement screen transition
        OnBoardingContentView(onboardingViewModel: onboardingViewModel)
    }
}

// MARK: OnboardingContentView
private struct OnBoardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack{
            Text("Onboarding!")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
