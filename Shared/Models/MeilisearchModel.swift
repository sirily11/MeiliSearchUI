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
    private var currentIndex: Index?
    private let context = PersistenceController.shared.container.viewContext
    
    
    private var meilisearchClient: MeiliSearch?
    
    @Published var indexes: [Index] = []
    @Published var currentSettings: SettingResult?
    @Published var tasks: [Task] = []
    @Published var stats: Stat?
    
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
}
