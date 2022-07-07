//
//  ErrorPopupIcon.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct ErrorPopupIcon: View {
    @State var showError: Bool = false
    var error: Error?
    
    var body: some View {
        Image(systemSymbol: .infoCircleFill)
            .foregroundColor(.red)
            .onTapGesture {
                showError = true
            }
            .popover(isPresented: $showError) {
                Text(error?.localizedDescription ?? "")
            }
    }
}
