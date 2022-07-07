//
//  IndexForm.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct IndexForm: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @Binding var isPresented: Bool
    
    @State var uid: String = ""
    @State var primaryKey: String = ""
    @State var error: Error?
    @State var isLoading = false
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            Form {
                if let _ = error {
                    HStack {
                        Spacer()
                        ErrorPopupIcon(error: error)
                    }
                }
                TextField("Uid", text: $uid)
                TextField("Primary Key", text: $primaryKey)
                HStack{
                    Button("Close", action: { isPresented = false })
                    Button(isLoading ? "Loading...": "Add"){
                        Task {
                            await create()
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(minWidth: 400)
        Spacer()
    }
    
    func create() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        Task {
            do {
                try await meilisearchModel.createIndex(uid: uid, primaryKey: primaryKey)
                isPresented = false
            } catch let error {
                self.error = error
            }
        }
        isLoading = false
    }
}
