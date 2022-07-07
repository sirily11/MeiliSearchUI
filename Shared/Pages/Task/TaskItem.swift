//
//  TaskItem.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI
import MeiliSearch

struct TaskItem: View {
    let task: Task
    
    var body: some View {
        HStack {
            VStack(alignment:.leading, spacing: 0) {
                Text(task.indexUid)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                if let percentage = task.percentage {
                    ProgressView(value: percentage)
                }
                Text("\(task.type) - \(task.status.stringValue) - \(task.duration ?? "")")
                    .font(.caption2)
                Text("\(task.enqueuedAt)")
                    .font(.caption2)
                
            }

        }
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        TaskItem(task: Task.createTestData())
    }
}
