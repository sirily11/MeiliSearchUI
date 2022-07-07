//
//  DocumentList.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import MeiliSearch

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
    @State var loading = false
    
    var body: some View {
        VStack{
            if let error = error {
                Spacer()
                ErrorLabel(error: error)
                Spacer()
            }
            
            if loading {
                Spacer()
                ProgressView()
                Spacer()
            }
            
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
            
            Table(people) {
                   TableColumn("Given Name", value: \.givenName)
                   TableColumn("Family Name", value: \.familyName)
                   TableColumn("E-Mail Address", value: \.emailAddress)
               }
        }
        .padding()
        .searchable(text: $searchText)
        .onChange(of: searchText) { text in
           
        }
        .task {
            withAnimation {
                loading = true
            }
            do {
                meilisearchModel.setIndex(index)
                try await meilisearchModel.fetchStats()
            } catch let error {
                self.error = error
            }
            
            withAnimation {
                loading = false
            }
        }
    }
}
