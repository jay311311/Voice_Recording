//
//  MemoListView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2023/12/20.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        ZStack{
            VStack{
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            memoListViewModel.tapNavigationRigthBtn()
                        },
                        rightBtnType: memoListViewModel.navigationBtyType
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                        .foregroundColor(.red)
                }
                // titleView
                TitleView()
                    .padding(.top, 20)
                
                // infoView
                if memoListViewModel.memos.isEmpty {
                    InfoView()
                } else {
                    // memoListView
                    ContenstView()
                        .padding(.top, 20)
                }
            }
            // floating Btn
            CreateMemoBtn()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "Will you delete \(memoListViewModel.removeMemosCount) memo\(memoListViewModel.removeMemosCount > 1 ? "s?" : "?" )",
            isPresented: $memoListViewModel.isDisplayMemoForRemove)
        {
            Button("Delete", role: .destructive) {
                memoListViewModel.removeMemo()
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
    }
}


// -MARK: Title View
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack{
            if memoListViewModel.memos.isEmpty {
                Text("Add your memos")
            } else {
                Text("There \(memoListViewModel.memos.count > 1 ? "are" : "is") \(memoListViewModel.memos.count).")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: Info View
private struct InfoView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image(systemName: "pencil")
                .font(.system(size: 25))
            VStack {
                Text("Meeting memo")
                Text("Speach memo")
                Text("Algorithm summary")
            }
            Spacer()
        }
        .font(.system(size: 14))
        .foregroundColor(.customIconGray)
    }
}

// -MARK: ContentsView
private struct ContenstView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack{
            HStack{
                Text("MemoList")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack{
                    Rectangle()
                        .fill(Color.customGreen2)
                        .frame(height: 1)
                    
                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        // MemoListCell
                        ListCellView(memo: memo)
                    }
                }
            }
        }
    }
}

// -MARK: ListCellView
private struct ListCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViModel: MemoListViewModel
    
    @State private var isRemoveSelected: Bool
    private var memo: MemoModel
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: MemoModel
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button(action: {
            pathModel.paths.append(.memoView(isCreateMode: false, memo: memo))
        }, label: {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(memo.title)")
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundColor(Color.customBlack)
                        
                        Text("\(memo.content)")
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .foregroundColor(Color.customGray2)
                        
                        Text("\(memo.convertedDate)")
                            .font(.system(size: 12))
                            .foregroundColor(Color.customIconGray)
                    }
                    Spacer()
                    
                    if memoListViModel.isEditMemoMode {
                        Button(action: {
                            isRemoveSelected.toggle()
                            memoListViModel.selectRemoveBtn(memo)
                        }, label: {
                            isRemoveSelected ? Image(systemName: "trash.fill") : Image(systemName: "trash")
                        })
                        .foregroundColor(isRemoveSelected ? .red : .customGray2)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        })
    }
}


// -MARK: Floating Btn
private struct CreateMemoBtn: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                
                Button(action: {
                    pathModel.paths.append(.memoView(isCreateMode: true, memo: nil))
                }, label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.customGreen1)
                        .font(.system(size: 50))
                })
            }
            
        }
        
    }
}


struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
            .environmentObject(PathModel())
            .environmentObject(MemoListViewModel())
    }
}
