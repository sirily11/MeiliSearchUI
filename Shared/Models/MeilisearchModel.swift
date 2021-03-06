//
//  Meilisearch.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation
import MeiliSearch
import SwiftUI



class MeilisearchModel: ObservableObject {
    var currentHost: Host?
    var currentIndex: Index?
    private let context = PersistenceController.shared.container.viewContext
    
    
    private var meilisearchClient: MeiliSearch?
    
    @Published var isLoading = false
    
    @Published var indexes: [Index] = []
    @Published var currentSettings: SettingResult?
    @Published var tasks: [Task] = []
    @Published var stats: Stat?
    @Published var searchResults: SearchResult<Document>?
    @Published var documents: [Document] = []
    
    
    /**
     Set current host
     */
    func setHost(_ host: Host) throws {
        currentHost = host
        meilisearchClient = try MeiliSearch(host: host.endpoint!, apiKey: host.password, session: nil, request: nil)
    }
    
    /**
     Set current index
     */
    func setIndex(_ index: Index) {
        currentIndex = index
    }
    
    /**
     Add new host if create or update existing host
     */
    func addorUpdateHost(endpoint: String, password: String) throws {
        let host = Host(context: context)
        host.endpoint = endpoint
        host.password = password
        try context.save()
    }
    
    func deleteHost(host: Host) throws {
        context.delete(host)
        try context.save()
    }
    
    /**
     Update Index
     */
    @MainActor
    func updateIndex(primaryKey: String) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        guard let currentIndex = currentIndex else {
            return
        }

        
        let task = try await meilisearchClient.index(currentIndex.uid).update(primaryKey: primaryKey)
        let _ = try await meilisearchClient.waitForTask(task: task)
        try await fetchIndexes()
        withAnimation{
            self.indexes = indexes
        }
    }
    
    /**
     Fetch all indexes
     */
    @MainActor
    func fetchIndexes() async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        let indexes = try await meilisearchClient.getIndexes()
        withAnimation{
            self.indexes = indexes
        }
    }
    
    @MainActor
    func createIndex(uid: String,  primaryKey: String) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        var pk: String? = primaryKey
        if pk?.count == 0{
            pk = nil
        }
        let _ = try await meilisearchClient.createIndex(uid: uid, primaryKey: pk)
        
        try await fetchIndexes()
    }
    
    @MainActor
    func deleteIndex() async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        guard let currentIndex = currentIndex else {
            return
        }

        let task = try await meilisearchClient.deleteIndex(uid: currentIndex.uid)
        let _ = try await meilisearchClient.waitForTask(task: task)
        try await fetchIndexes()
    }
    
    /**
     Fetching settings by index
     */
    @MainActor
    func fetchSettings() async throws{
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        guard let currentIndex = currentIndex else {
            return
        }

        
        let settings = try await meilisearchClient.index(currentIndex.uid).getSettings()
        currentSettings = settings
    }
    
    /**
     Update settings by index
     */
    func updateSettings(setting: Setting) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        guard let currentIndex = currentIndex else {
            return
        }
    
        let _ = try await meilisearchClient.index(currentIndex.uid).updateSettings(settings: setting)
    }
    
    /**
     Fetch index
     */
    func fetchIndex(uid: String) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        let index = try await meilisearchClient.getIndex(uid)
        currentIndex = index
    }
    
    /**
     Fetch stats
     */
    @MainActor
    func fetchStats() async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }
        
        guard let currentIndex = currentIndex else {
            return
        }

        
        let stats = try await meilisearchClient.index(currentIndex.uid).stats()
        withAnimation {
            self.stats = stats
        }
    }
    
    
    /**
     Fetching settings by index
     */
    @MainActor
    func fetchTasks() async throws{
        guard let meilisearchClient = meilisearchClient else {
            return
        }

        if let currentIndex = currentIndex {
            let tasks = try await meilisearchClient.index(currentIndex.uid).getTasks()
            withAnimation {
                self.tasks = tasks
            }
            
        } else {
            let tasks = try await meilisearchClient.getTasks()
            withAnimation {
                self.tasks = tasks
            }
        }
    }
    
    /**
     Fetching settings by index
     */
    @MainActor
    func search(keyword: String) async throws{
        guard let meilisearchClient = meilisearchClient else {
            return
        }

        guard let currentIndex = currentIndex else {
            return
        }
        
        let results = try await meilisearchClient.index(currentIndex.uid).search(.query(keyword))
        self.searchResults = results
        self.documents = results.hits
    }
    
    /**
     Add document from url
     */
    @MainActor
    func addDocument(url: URL) async throws {
        let content = try String(contentsOfFile: url.path)
        try await addDocument(content: content)
    }
    
    /**
     Add document from content
     */
    @MainActor
    func addDocument(content: String) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }

        guard let currentIndex = currentIndex else {
            return
        }
        let task = try await meilisearchClient.index(currentIndex.uid).addDocument(data: content.data(using: .utf8)!)
        let _ = try await meilisearchClient.waitForTask(task: task)
        try await fetchStats()
        try await fetchDocuments()
    }
    
    /**
     Fetch document from content
     */
    @MainActor
    func fetchDocuments() async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }

        guard let currentIndex = currentIndex else {
            return
        }
        let documents = try await meilisearchClient.index(currentIndex.uid).getDocuments(options: GetParameters(limit: 20))
        self.documents = documents
    }
    
    
    
    /**
     Add document from content
     */
    @MainActor
    func deleteDocument(document: Document, primaryKey: String) async throws {
        guard let meilisearchClient = meilisearchClient else {
            return
        }

        guard let currentIndex = currentIndex else {
            return
        }
        
        let task = try await meilisearchClient.index(currentIndex.uid).deleteDocument(primaryKey: document.value[primaryKey].stringValue)
        let _ = try await meilisearchClient.waitForTask(task: task)
        try await fetchStats()
        
        // delete document
        if let documentIndex = documents.firstIndex(of: document) {
            documents.remove(at: documentIndex)
        }
    }
    
}
