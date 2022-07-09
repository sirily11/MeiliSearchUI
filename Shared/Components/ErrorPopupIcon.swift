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
                VStack {
                    Text(error?.localizedDescription ?? "")
                        .padding()
                }
                .lineLimit(nil)
                .frame(maxWidth: 300, maxHeight: 300)
                .fixedSize(horizontal: false, vertical: true)
            }
    }
}

struct ErrorPopupIcon_Previews: PreviewProvider {
    static var previews: some View {
        ErrorPopupIcon( error: MeilisearchError.taskFailed(type: "Invalid Index", reason: "Some very very very very very very long error"))
    }
}

