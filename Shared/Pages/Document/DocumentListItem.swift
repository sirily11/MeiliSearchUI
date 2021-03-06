//
//  DocumentListItem.swift
//  MeiliSearchUI
//
//  Created by Qiwei Li on 7/7/22.
//

import SwiftUI
import SwiftyJSON
import SwiftJSONView

struct DocumentListItem: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    let columns: [DocumentColumn]
    let data: Document
    let primaryKey: String
    
    @State var open = false
    @State var error: Error?
    @State var loading = false
    
    func getTitleFromColumns() -> String{
        var title = ""
        for column in columns {
            let content = data.value[column.name]
            if let value = content.string {
                title += "\(column.name): \(value),     "
            }
            
            if let _ = content.dictionary {
                title += "\(column.name): {...},    "
            }
            
            if let _ = content.array {
                title += "\(column.name): [...],    "
            }
            
        }
        return title
    }
    
    var body: some View {
        HStack {
            Text("Document: { \(getTitleFromColumns()) }")
                .lineLimit(1)
            Spacer()
            if loading {
                ProgressView()
            } else if let error = error {
                ErrorPopupIcon(error: error)
            } else {
                Image(systemSymbol: .infoCircleFill)
                    .onTapGesture {
                        open = true
                    }
                    .popover(isPresented: $open) {
                        ScrollView{
                            SwiftJSONView(data: data.value)
                        }
                            .frame(minWidth: 400, minHeight: 500)
                            .padding()
                    }
            }
        }
        .contextMenu{
            Button("Delete document") {
                Task {
                    await delete()
                }
            }
        }
        .padding()
    }
    
    func delete() async {
        do {
            try await meilisearchModel.deleteDocument(document: data, primaryKey: primaryKey)
        } catch let error {
            self.error = error
        }
    }
}

struct DocumentListItem_Previews: PreviewProvider {
    static let data: JSON = [
        "hello": "World",
        "names": ["a", "b"],
        "properties": [
            "name": "a"
        ]
    ]
    
    static var previews: some View {
        DocumentListItem(
            columns: [
                DocumentColumn(name: "hello", value: 1),
                DocumentColumn(name: "names", value: 1),
                DocumentColumn(name: "properties", value: 2)
            ],
            data: Document(value: data),
            primaryKey: "name"
        )
    }
}
