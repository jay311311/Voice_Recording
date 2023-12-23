//
//  MemoView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/30.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel: MemoViewModel
    
    @State var isCreateMode: Bool
    
    var body: some View {
        ZStack{
            VStack{
                CustomNavigationBar(
                    leftBtnAction: {
                        pathModel.paths.removeLast()
                    },
                    rightBtnAction: {
                        if isCreateMode {
                            memoListViewModel.addMemo(memoViewModel.memo)
                        } else {
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                        if !pathModel.paths.isEmpty {
                            pathModel.paths.removeLast()
                        }
                    },
                    rightBtnType: isCreateMode ? .create : .complete
                )
                
                // memoTitle inputView
                MemoTitleInputView(
                    memoViewModel: memoViewModel,
                    isCreateMode: $isCreateMode
                )
                
                //memocontents inputView
                MemoContentsView(memoViewModel: memoViewModel)
                
            }
            // delete floating Btn
            if !isCreateMode {
                memoDelteFloatBtn(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
            }
        }
    }
}

// - MARK: memoTitle InputView
private struct MemoTitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isFocuseTitleField: Bool
    @Binding private var isCreateMode: Bool
    
    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreateMode: Binding<Bool>) {
            self.memoViewModel = memoViewModel
            self._isCreateMode = isCreateMode
        }
    
    fileprivate var body: some View {
        TextField(
            "Enter your Title"
            , text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal,20)
        .focused($isFocuseTitleField)
        .onAppear{
            if isCreateMode {
                isFocuseTitleField = true
            }
        }
    }
}

// - MARK: memoContentsView
private struct MemoContentsView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("Enter your Memo")
                    .font(.system(size: 16))
                    .foregroundColor(.customGray1)
                    .allowsHitTesting(true)
                    .padding(.top, 10)
                    .padding(.leading, 5)
                
            }
        }
        .padding(.horizontal, 20)
    }
}

// - MARK: MemoDeleteFloating Btn

private struct memoDelteFloatBtn: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject var memoViewModel: MemoViewModel
    
    fileprivate init( memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                
                Button(action: {
                    memoListViewModel.remove(memoViewModel.memo)
                    pathModel.paths.removeLast()
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                })
            }
        }
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView(
            memoViewModel: .init(
                memo: .init(
                    title: "",
                    content: "",
                    date: Date()
                )
            ), isCreateMode: true
        )
    }
}
