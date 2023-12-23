//
//  MemoViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/20.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: MemoModel
    
    init( memo: MemoModel) {
        self.memo = memo
    }
}
