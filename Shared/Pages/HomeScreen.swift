//
//  ContentView.swift
//  Shared
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import CoreData
import SFSafeSymbols

struct HomeScreen: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var hosts: FetchedResults<Host>
    @State var showInfo = false
    @State var showAddDocument = false

    var body: some View {
        NavigationView {
          HostList()
          Text("Pick a host")
          Text("Meilisearch UI")
        }
        .toolbar{
            ToolbarItemGroup {
                if meilisearchModel.isLoading {
                    ProgressView()
                }
                
                if meilisearchModel.currentIndex != nil {
                    Button(action: {
                      showAddDocument = true
                    }, label: {
                        Image(systemSymbol: .plus)
                    })
                    .popover(isPresented: $showAddDocument) {
                        DocumentForm(isPresented: $showAddDocument)
                            .frame(width: 500, height: 500)
                    }
                }
                
                if meilisearchModel.currentHost != nil {
                    Button(action: {
                        showInfo = true
                    }, label: {
                        Image(systemSymbol: .infoCircleFill)
                    })
                        .popover(isPresented: $showInfo) {
                            TaskList()
                                .frame(width: 400, height: 400)
                        }
                    }
                
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
