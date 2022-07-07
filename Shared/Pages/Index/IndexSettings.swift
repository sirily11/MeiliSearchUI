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
    
    @State var loading = false
    @State var error: Error?
    @State var saving = false
    
    @State var rankingRules: [String] = []
    @State var filterableAttributes: [String] = []
    @State var searchableAttributes: [String] = []
    @State var displayedAttributes: [String] = []
    

    var body: some View {
        ScrollView{
            VStack {
                if let error = error {
                    HStack {
                        Spacer()
                        ErrorPopupIcon(error: error)
                    }
                }
                
                
                if let _ = meilisearchModel.currentSettings {
                    HStack {
                        Form {
                            SettingsList(title: "Ranking rules", settings: $rankingRules)
                            SettingsList(title: "filterableAttributes",settings: $filterableAttributes)
                            SettingsList(title: "SearchableAttributes",settings: $searchableAttributes)
                            SettingsList(title: "DisplayedAttributes",settings: $displayedAttributes)
                        }
                    }
                    Spacer()
                }
                Spacer()
                if loading {
                    ProgressView()
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
            withAnimation{
                loading = true
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
                loading = false
            }
        }
        .navigationTitle("Settings")
    }
    
    func update() async {
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
            withAnimation{
                saving = false
            }
            
        } catch let error{
            self.error = error
        }
    }
}


