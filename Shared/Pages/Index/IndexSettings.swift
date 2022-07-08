//
//  IndexSettings.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import MeiliSearch

fileprivate typealias SwiftTask = SwiftUI.Task

struct IndexSettings: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @State var selection: Int = 0
    
    @State var loading = false
    @State var error: Error?
    @State var saving = false
    
    @State var rankingRules: [String] = []
    @State var filterableAttributes: [String] = []
    @State var searchableAttributes: [String] = []
    @State var displayedAttributes: [String] = []
    @State var primaryKey: String = ""
    
    
    var body: some View {
        ScrollView{
            VStack {
                if let error = error {
                    HStack {
                        Spacer()
                        ErrorPopupIcon(error: error)
                    }
                }
                
                
                TabView(selection: $selection) {
                    if let _ = meilisearchModel.currentIndex {
                        GeneralSettings(title: "General", primaryKey: $primaryKey)
                            .tag(0)
                    }
                    if let _ = meilisearchModel.currentSettings {
                        SettingsList(title: "Ranking rules", settings: $rankingRules)
                            .tag(1)
                        SettingsList(title: "Filterable Attributes",settings: $filterableAttributes)
                            .tag(2)
                        SettingsList(title: "Searchable Attributes",settings: $searchableAttributes)
                            .tag(3)
                        SettingsList(title: "Displayed Attributes",settings: $displayedAttributes)
                            .tag(4)
                        
                        Spacer()
                    }
                }
                Spacer()
                
                if let _ = meilisearchModel.currentSettings {
                    HStack {
                        Spacer()
                        Button(saving ? "Saving...": "Save") {
                            SwiftTask {
                                await update()
                            }
                        }
                    }
                }
            }
            
            .padding()
        }
        .task{
          setup()
          await fetchSettings()
        }
        .navigationTitle("Settings")
    }
    
    func setup(){
        if let currentIndex = meilisearchModel.currentIndex {
            primaryKey = currentIndex.primaryKey ?? ""
        }
    }
    
    func fetchSettings()async {
        withAnimation{
            meilisearchModel.isLoading = true
        }
        do {
            try await meilisearchModel.fetchSettings()
            if let settings = meilisearchModel.currentSettings {
                rankingRules = settings.rankingRules
                searchableAttributes = settings.searchableAttributes
                displayedAttributes = settings.displayedAttributes
                filterableAttributes = settings.filterableAttributes
            }
        } catch let error {
            self.error = error
        }
        withAnimation{
            meilisearchModel.isLoading = false
        }
    }
    
    func update() async {
        if selection == 0 {
            await updateIndex()
        } else {
            await updateSettings()
        }
    }
    
    func updateIndex() async {
        withAnimation{
            saving = true
        }
        do {
            try await meilisearchModel.updateIndex(primaryKey: primaryKey)
        } catch let error {
            self.error = error
        }
        withAnimation{
            saving = false
        }
    }
    
    func updateSettings() async {
        do {
            withAnimation{
                saving = true
            }
            try await SwiftTask.sleep(nanoseconds: 500_000_000)
            
            if let currentSettings = meilisearchModel.currentSettings {
                let setting = Setting(rankingRules: rankingRules, searchableAttributes: searchableAttributes, displayedAttributes: displayedAttributes, stopWords: currentSettings.stopWords, synonyms: currentSettings.synonyms, distinctAttribute: currentSettings.distinctAttribute, filterableAttributes: filterableAttributes, sortableAttributes: currentSettings.sortableAttributes)
                try await meilisearchModel.updateSettings(setting: setting)
                error = nil
            }
        } catch let error{
            self.error = error
        }
        withAnimation{
            saving = false
        }
        
    }
}


