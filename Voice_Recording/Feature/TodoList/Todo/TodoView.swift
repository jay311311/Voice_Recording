//
//  TodoView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/11/30.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()

    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()
                },
                rightBtnAction: {
                    if !todoViewModel.title.isEmpty {
                        todoListViewModel.addTodo(
                            .init(
                                title: todoViewModel.title,
                                time: todoViewModel.time,
                                day: todoViewModel.day,
                                selected: false)
                        )
                        
                        pathModel.paths.removeLast()
                    }
                },
                rightBtnType: .create
            )
            // title View
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            // todo titleView(textField)
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            // time view
            SelectionTimeView(todoViewModel: todoViewModel)
            
            
            // date view
            SelectionDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
        }
    }
}

// MARK: Title View
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("Add your Todo List")
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: Todo Title View
private struct TodoTitleView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField(
            "Enter Your Title",
            text: $todoViewModel.title)
        .onChange(of: todoViewModel.title) { newValue in
            todoViewModel.getIsTitleEmpty(newValue.isEmpty)
//            print("TextField \(newValue) // \(newValue.isEmpty)")
        }
    }
}

// MARK: selecTion Title View
private struct SelectionTimeView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: Selction Day View
private struct SelectionDayView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Day")
                    .foregroundColor(.customIconGray)
                
                Spacer()
            }
            
            HStack {
                Button {
                    todoViewModel.setIsDisplayCalendar(true)
                } label: {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.customGreen1)
                }
                .popover(
                    isPresented: $todoViewModel.isDisplayCalendar) {
                        DatePicker(
                            "",
                            selection: $todoViewModel.day,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onChange(of: todoViewModel.day) { _ in
                            todoViewModel.setIsDisplayCalendar(false)
                        }
                    }
                Spacer()
            }
        }
    }
}


struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
