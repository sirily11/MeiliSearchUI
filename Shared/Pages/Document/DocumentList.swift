//
//  DocumentList.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import MeiliSearch
import SwiftJSONView

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let emailAddress: String
    let id = UUID()
}
private var people = [
    Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
    Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
    Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
    Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com")
]

struct DocumentList: View {
    let index: Index
    
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @State var searchText: String = ""
    @State var error: Error?
    @State private var dragOver = false
    @State var showSearchResult = false
    @State var selections: Set<Document> = Set()
    
    var body: some View {
        VStack{
            if let stats = meilisearchModel.stats {
                HStack {
                    Text("Number of documents")
                    Text("\(stats.numberOfDocuments)")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Is Indexing")
                    Text(stats.isIndexing.description)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            if let error = error {
                ErrorLabel(error: error)
                Spacer()
            }
            
            if let searchResult = meilisearchModel.searchResults {
                HStack {
                    Text("Total: \(searchResult.nbHits)")
                        .bold()
                    Spacer()
                    Text("Time: \(searchResult.processingTimeMs ?? 0) ms")
                        .bold()
                }
            }
            
            // show search results
            if let columns = meilisearchModel.stats?.columns {
                    Table(meilisearchModel.documents) {
                        TableColumn("ID") { document in
                            Text("\(document.value[index.primaryKey ?? ""].stringValue)")
                        }
                        .width(200)
                        
                        TableColumn("Raw Data") { document in
                            DocumentListItem(columns: columns, data: document, primaryKey: index.primaryKey ?? "")
                        }
                    }
                
            }
        }
        .padding()
        .searchable(text: $searchText)
        .onChange(of: searchText) { text in
            SwiftUI.Task {
                if text.isEmpty {
                    return
                }
                withAnimation{
                    meilisearchModel.isLoading = true
                }
                do {
                    try await meilisearchModel.search(keyword: text)
                } catch let error {
                    self.error = error
                }
                withAnimation{
                    meilisearchModel.isLoading = false
                }
            }
        }
        .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
            providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                    DispatchQueue.main.async {
                        SwiftUI.Task {
                            do {
                                try await meilisearchModel.addDocument(url: url)
                            } catch let error {
                                self.error = error
                            }
                        }
                    }
                }
            })
            return true
        }
        .task {
            withAnimation {
                meilisearchModel.isLoading = true
            }
            do {
                meilisearchModel.setIndex(index)
                try await meilisearchModel.fetchStats()
                try await meilisearchModel.fetchDocuments()
            } catch let error {
                self.error = error
            }
            
            withAnimation {
                meilisearchModel.isLoading = false
            }
        }
    }
}
