//
//  HostList.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct HostList: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var hosts: FetchedResults<Host>
    
    @State var showAddForm = false
    
    var body: some View {
        List {
            ForEach(hosts) { host in
                HostItem(host: host)
            }
        }
        .frame(minWidth: 200)
        .contextMenu{
            Button("Add Item") {
                showAddForm = true
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { showAddForm = true }) {
                    Label("Add Item", systemSymbol: .plus)
                }
            }
        }
        .sheet(isPresented: $showAddForm) {
            HostForm(isPresented: $showAddForm)
        }
    }
}

struct HostList_Previews: PreviewProvider {
    static var previews: some View {
        HostList()
    }
}
