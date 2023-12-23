//
//  MemoListViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/20.
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [MemoModel]
    @Published var isEditMemoMode: Bool
    @Published var memosForRemove: [MemoModel]
    @Published var isDisplayMemoForRemove: Bool
    
    var removeMemosCount: Int {
        return memosForRemove.count
    }
    var navigationBtyType: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(
        memos: [MemoModel] = [],
        isEditMemoMode: Bool = false,
        memosForRemove: [MemoModel] = [],
        isDisplayMemoForRemove: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.memosForRemove = memosForRemove
        self.isDisplayMemoForRemove = isDisplayMemoForRemove
    }
}

extension MemoListViewModel {
    func addMemo(_ memo: MemoModel) {
        memos.append(memo)
        print(memos)
    }
    
    func updateMemo(_ memo: MemoModel) {
        if let index = memos.firstIndex(where: { $0.id == memo.id}) {
            memos[index] = memo
        }
    }
    
    func remove(_ memo: MemoModel) {
        if let index = memos.firstIndex(where: { $0.id == memo.id}) {
            memos.remove(at: index)
        }
    }
    
    func tapNavigationRigthBtn() {
        if isEditMemoMode {
            if memosForRemove.isEmpty {
                isEditMemoMode = false
            } else {
                // TODO: alert을 위한 상태갑 변경을 위한 메서드 호출
                setIsDisplayMemoForRemove(true)
            }
        } else {
            isEditMemoMode = true
        }
    }
    
    func setIsDisplayMemoForRemove(_ isDisplay: Bool){
        isDisplayMemoForRemove = isDisplay
    }
    
    func selectRemoveBtn(_ memo: MemoModel) {
        if let index = memosForRemove.firstIndex(of: memo) {
            memosForRemove.remove(at: index)
        } else {
            memosForRemove.append(memo)
        }
    }
    
    func removeMemo() {
        memos.removeAll { memo in
            memosForRemove.contains(memo)
        }
        memosForRemove.removeAll()
        isEditMemoMode = false
    }
}

