//
//  TaskList.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct TaskList: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @State var loading = false
    @State var error: Error?
    
    var body: some View {
        List {
            HStack {
                Spacer()
                Text("Tasks")
                if let _ = error {
                    ErrorPopupIcon(error: error)
                }
                Spacer()
            }
            ForEach(meilisearchModel.tasks, id: \.uid) { task in
                TaskItem(task: task)
                Divider()
            }
        }
        .listStyle(.sidebar)
        .task {
            withAnimation{
                loading = true
            }
            do {
                try await meilisearchModel.fetchTasks()

            } catch let error {
                self.error = error
            }
            
            withAnimation {
                loading = false
            }
        }
    }
    
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList()
    }
}
