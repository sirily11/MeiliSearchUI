//
//  IndexList.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct IndexList: View {
    let host: Host
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @State var error: Error?
    @State var loading = false
    @State var isPresented = false
    
    var body: some View {
        List{
            if let error = error {
                VStack {
                    ErrorLabel(error: error)
                }
            }
            if loading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
            ForEach(meilisearchModel.indexes, id: \.uid) { index in
                IndexItem(index: index)
                Divider()
            }
            
        }
        .frame(minWidth: 400)
        .contextMenu{
            Button("Add a new index") {
                isPresented = true
            }
        }
        .sheet(isPresented: $isPresented){
            IndexForm(isPresented: $isPresented)
        }
        .task {
            withAnimation{
                loading = true
            }
            do {
                try meilisearchModel.setHost(host)
                try await meilisearchModel.fetchIndexes()
            } catch let error {
                self.error = error
            }
            withAnimation{
                loading = false
            }
        }
    }
}
