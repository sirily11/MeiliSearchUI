//
//  IndexItem.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import MeiliSearch

fileprivate typealias SwiftTask = SwiftUI.Task

struct IndexItem: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @State var isDeleting = false
    @State var error: Error?
    @State var isEditing = false
    
    let index: Index
    
    var body: some View {
        NavigationLink {
            DocumentList(index: index)
        } label: {
            NavigationLink(isActive: $isEditing) {
                IndexSettings()
            } label: {
                EmptyView()
            }

            
            HStack {
                VStack(alignment: .leading){
                    Text("\(index.uid)")
                        .fontWeight(.bold)
                    Text("Primary Key: \(index.primaryKey ?? "")")
                }
                Spacer()
                if isDeleting {
                    ProgressView()
                        .padding()
                }
            }
            .frame(minHeight: 60)
        }
        .contextMenu{
            Button("Edit Settings") {
                edit()
            }
            Button("Delete") {
                SwiftTask {
                     await delete()
                }
            }
        }
    }
    
    func edit() {
        meilisearchModel.setIndex(index)
        isEditing = true
    }
    
    func delete() async {
        isDeleting = true
        do {
            meilisearchModel.setIndex(index)
            try await meilisearchModel.deleteIndex()
        } catch let error {
            self.error = error
        }
        isDeleting = false
    }
    
}
