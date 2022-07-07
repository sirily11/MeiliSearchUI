//
//  SettingsTableView.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import SwiftUI

struct SettingsList: View {
    let title: String
    @Binding var settings: [String]
   
    @State var selectKeeper = Set<String>()
    @State var showAdd = false
    @State var addValue = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                
                Button {
                    showAdd = true
                } label: {
                    Image(systemSymbol: .plus)
                }
                .popover(isPresented: $showAdd) {
                    VStack {
                        TextField("Value", text: $addValue)
                            .onSubmit {
                                add()
                            }
                    }
                    .padding()
                    .frame(width: 300, height: 100)
                }
                
                Button {
                    remove()
                } label: {
                    Image(systemSymbol: .minus)
                }
                .disabled(selectKeeper.isEmpty)
                
                Spacer()
            }
            
            List(settings, id: \.self, selection: $selectKeeper) { value in
                Text(value)
            }
            .frame(minHeight: 500, maxHeight: 500)
            .onDeleteCommand{
              
            }
        }
        .padding()
        .tabItem{
            Label(title, systemSymbol: .return)
        }
        
    }
    
    func add(){
        settings.append(addValue)
        addValue = ""
        showAdd = false
    }
    
    func remove(){
        selectKeeper.forEach { selection in
            if let index: Int = selectKeeper.firstIndex(of: selection) {
                settings.remove(at: index)
            }
        }
        
        selectKeeper = Set<String>()
    }
}
