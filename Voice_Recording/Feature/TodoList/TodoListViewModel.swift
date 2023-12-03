//
//  TodoListViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/02.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoModel]
    @Published var isEditTodoMode: Bool
    @Published var todosForRemove: [TodoModel]
    @Published var isDisplayTodoForRemoveAlert: Bool
    
    var todosForRemoveCount: Int {
        return todosForRemove.count
    }
    
    var navigationBtnType: NavigationBtnType {
       isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [TodoModel] = [],
        isEditModeForTodo: Bool = false,
        todosForRemove: [TodoModel] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditModeForTodo
        self.todosForRemove = todosForRemove
        self.isDisplayTodoForRemoveAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {
    func selecteCheckBox(_ todo: TodoModel) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: TodoModel) {
        todos.append(todo)
    }
    
    func tapNavigationRightBtn() {
        if isEditTodoMode {
            if todosForRemove.isEmpty {
                isEditTodoMode = false
            } else {
                setIsDisplayTodoForRemoveAlert(true)
            }
        } else {
            isEditTodoMode = true
        }
    }
    
    func setIsDisplayTodoForRemoveAlert(_ isDisplay: Bool) {
        isDisplayTodoForRemoveAlert = isDisplay
    }
    
    func selectRemoveBtn(_ todo: TodoModel) {
        if let index = todosForRemove.firstIndex(where: { $0 == todo}) {
            todosForRemove.remove(at: index)
        } else {
            todosForRemove.append(todo)
        }
    }
    
    func removeTodo() {
        todos.removeAll { todo in
            todosForRemove.contains(todo)
        }
        todosForRemove.removeAll()
        isEditTodoMode = false
    }
    
    
}


