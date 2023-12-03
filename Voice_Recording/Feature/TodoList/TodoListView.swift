//
//  TodoListView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/02.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            VStack{
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction:  {
                            todoListViewModel.tapNavigationRightBtn()
                        },
                        rightBtnType: todoListViewModel.navigationBtnType
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
               TitleVIew()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    InfoView()
                } else {
                    ContentsView()
                }
            }
            
            CreateTodoBtnView()
                .frame(width: 50, height: 50)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
                
        }
        .alert(
            "Will you delete \(todoListViewModel.todosForRemove.count) list?",
            isPresented: $todoListViewModel.isDisplayTodoForRemoveAlert
        ) {
            Button("delete", role: .destructive) {
                todoListViewModel.removeTodo()
            }
            Button("cancel", role: .cancel) { }
        }
    }
}

// MARK: TodoList Title View
private struct TitleVIew: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("Add your todo list")
            } else {
                Text("there is \(todoListViewModel.todos.count) todo lists")
            }
            Spacer()
            
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: TodoList Info View
private struct InfoView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image(systemName: "square.and.pencil")
            Text("Go to the gym at 7PM")
            Text("Hang out with friends at 7PM")
            Text("Make a appoinment to doctor")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: TodoList contents View
private struct ContentsView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack{
                Text("Todo List")
                    .font(.system(size:16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customBlack)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // TODO: - todo 셀 뷰 쌔애 넣어서 뷰 호출
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
        
    }
}

// MARK: TodoList Cell View
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isSelectedForRemove: Bool
    private var todo: TodoModel
    
    fileprivate init(
        isSelectedForRemove: Bool = false,
        todo: TodoModel) {
        _isSelectedForRemove = State(initialValue:  isSelectedForRemove)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button {
                        todoListViewModel.selecteCheckBox(todo)
                    } label: {
                        todo.selected ?  Image(systemName: "checkmark.square") : Image(systemName: "square")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                    
                    Text(todo.comvertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isSelectedForRemove.toggle()
                        todoListViewModel.selectRemoveBtn(todo)
                    } label: {
                        isSelectedForRemove ? Image(systemName: "trash") : Image(systemName: "trash.fill")
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: Create Todo Buton

private struct CreateTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.customGreen1)
                }

            }
        }
    }
}


struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(TodoListViewModel())
            .environmentObject(PathModel())
    }
}
