//
//  HostForm.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct HostForm: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @Binding var isPresented: Bool
    
    @State var endpoint: String = ""
    @State var password: String = ""
    @State var error: Error?
    
    var body: some View {
       Spacer()
        HStack{
            Spacer()
            Form {
                if let _ = error {
                    HStack{
                        Spacer()
                        ErrorPopupIcon(error: error)
                    }
                }
                
                TextField("API Endpoint", text: $endpoint)
                TextField("Password", text: $password)
                
                HStack{
                    Button("Close") {
                        isPresented = false
                    }
                    
                    Button("Add") {
                        do {
                            try meilisearchModel.addorUpdateHost(endpoint: endpoint, password: password)
                            isPresented = false
                        } catch let error {
                            self.error = error
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(minWidth: 400)
        Spacer()
    }
    
    
}
