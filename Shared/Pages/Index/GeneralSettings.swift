//
//  GeneralSettings.swift
//  MeiliSearchUI
//
//  Created by Qiwei Li on 7/8/22.
//

import SwiftUI

struct GeneralSettings: View {
    let title: String
    @Binding var primaryKey: String
    
    var body: some View {
        Form {
            TextField("Primary Key", text: $primaryKey)
                .padding()
            Spacer()
        }
            .frame(height: 400)
            .tabItem{
                Label(title, systemSymbol: .return)
            }
    }
}
