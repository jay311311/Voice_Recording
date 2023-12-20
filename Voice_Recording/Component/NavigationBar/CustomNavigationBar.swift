//
//  CustomNavigationBar.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/01.
//

import SwiftUI

struct CustomNavigationBar: View {

    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction:() -> Void
    let rightBtnAction:() -> Void
    let rightBtnType: NavigationBtnType
//    @State private var showingAlert = true

    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        rightBtnType: NavigationBtnType = .edit) {
//        showingAlert: Bool = false
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
//        _showingAlert = State(initialValue: showingAlert)
    }
    
    var body: some View{
        HStack {
            Button {
                leftBtnAction()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.customBlack)
            }

            Spacer()
            
            Button {
                rightBtnAction()
            } label: {
                if rightBtnType == .close {
                    Image(systemName: "xmark")
                        .foregroundColor(.customBlack)
                } else {
                    Text(rightBtnType.rawValue)
                        .foregroundColor(.customBlack)
                }
            }
//            .alert(
//                "Enter your todo Title",
//                isPresented: $showingAlert) {
//                    Button(
//                        "OK",
//                        role: .destructive,
//                        action: { print("여기여기 11\(showingAlert)")}
//                    )
//
//                }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}


struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar()
    }
}
