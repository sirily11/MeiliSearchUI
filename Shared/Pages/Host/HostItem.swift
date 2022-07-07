//
//  HostItem.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct HostItem: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    @State var error: Error?
    
    var host: Host
    
    var body: some View {
        NavigationLink {
            IndexList(host: host)
        } label: {
            HStack{
                Text(host.endpoint!)
                Spacer()
                if let _ = error {
                    ErrorPopupIcon(error: error)
                }
            }
        }
        .contextMenu{
            Button("Delete host") {
                do {
                    try meilisearchModel.deleteHost(host: host)
                } catch let error {
                    self.error = error
                }
            }
        }
    }
}
