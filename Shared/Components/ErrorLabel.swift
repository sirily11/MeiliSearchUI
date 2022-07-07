//
//  ErrorLabel.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct ErrorLabel: View {
    let error: Error
    
    
    var body: some View {
        VStack {
            Text(error.localizedDescription)
        }
    }
}

struct ErrorLabel_Previews: PreviewProvider {
    static var previews: some View {
        ErrorLabel(error: MeilisearchError.unableToFetchIndexes)
    }
}
