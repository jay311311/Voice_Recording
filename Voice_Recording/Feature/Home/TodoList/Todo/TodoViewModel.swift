//
//  TodoViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/04.
//

import Foundation

class TodoViewModel: ObservableObject {
    
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isDisplayCalendar: Bool
    @Published var isEmptyTitle : Bool
//    @Published var isEmptyTitle: Bool?

//    static func == (lhs: TodoViewModel, rhs: TodoViewModel) -> Bool {
//        return lhs.title == rhs.title
//    }
    
    init(
        title: String = "",
        time: Date = Date(),
        day: Date = Date(),
        isDisplayCalendar: Bool = false,
        isEmptyTitle: Bool = false
//        isEmptyTitle: Bool? = nil
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isDisplayCalendar = isDisplayCalendar
        self.isEmptyTitle = isEmptyTitle
//        self.isEmptyTitle = isEmptyTitle
    }
}

extension TodoViewModel {
    func setIsDisplayCalendar(_ isDisplay: Bool) {
        isDisplayCalendar = isDisplay
    }
    
    func getIsTitleEmpty(_ isEmpty: Bool) {
        isEmptyTitle = isEmpty
    }
}
