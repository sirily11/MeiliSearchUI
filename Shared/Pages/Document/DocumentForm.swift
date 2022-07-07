//
//  DocumentForm.swift
//  MeiliSearchUI
//
//  Created by Qiwei Li on 7/7/22.
//

import SwiftUI

struct DocumentForm: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @Binding var isPresented: Bool
    @State var data: String = ""
    @State var loading: Bool = false
    @State var error: Error?
    
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                if loading {
                    Text("Loading...")
                }
                
                if let error = error {
                    ErrorPopupIcon(error: error)
                }
            }
            
            Text("Document Data")
            TextEditor(text: $data)
                .lineLimit(10)
            
            HStack {
                Spacer()
                Button("Submit") {
                    Task{
                       await submit()
                    }
                }
                .background(.blue)
            }
        }
        .padding()

    }
    
    func submit() async {
        loading = true
        error = nil
        do {
            try await meilisearchModel.addDocument(content: data)
            isPresented = false
        } catch let error {
            self.error = error
        }
        
        loading = false
    }
}
