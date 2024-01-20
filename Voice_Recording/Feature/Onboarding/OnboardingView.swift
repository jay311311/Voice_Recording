//
//  OnboardingView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/29.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var pathModel = PathModel()
    @StateObject private var todoListVieModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
//            OnboardingView(onboardingViewModel: onboardingViewModel)
            VoiceRecoderView()
                .environmentObject(memoListViewModel)
                .navigationDestination(
                    for: PathType.self,
                    destination: { pathType in
                        switch pathType {
                        case .homeView:
                            HomeView()
                                .navigationBarBackButtonHidden()
                        case let .memoView(isCreateMode, memo):
                            MemoView(
                                memoViewModel: isCreateMode
                                ? .init(memo: .init(title: "", content: "", date: .now))
                                : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                                isCreateMode: isCreateMode
                                )
                                .environmentObject(memoListViewModel)
                                .navigationBarBackButtonHidden()
                        case .todoView:
                            TodoView()
                                .environmentObject(todoListVieModel)
                                .navigationBarBackButtonHidden()
                        }
                    })
        }
        .environmentObject(pathModel)
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
            OnboardingListView(onboardingViewModel: onboardingViewModel)
            Spacer()
            StartButtonView()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: OnboardingListView
private struct OnboardingListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onboardingModel.enumerated()), id: \.element) {index, onboardingContent  in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0
            ? Color.customBackgroundGreen
            : Color.customBeige
        )
        .clipped()
    }
}

// MARK: OnboardingCellView
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingModel
    
    fileprivate init(onboardingContent: OnboardingModel) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack{
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
                .padding(.top, 62)
                
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

// MARK: StartButtonView

private struct StartButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View{
        Button {
            pathModel.paths.append(.homeView)
        } label: {
            HStack{
                Text("Start")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customGreen1)
                
                Image(systemName: "arrow.right")
                    .renderingMode(.template)
                    .foregroundColor(.customGreen1)
            }
        }
        .padding(.bottom, 50)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
