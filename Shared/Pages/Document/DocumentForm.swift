//
//  DocumentForm.swift
//  MeiliSearchUI
//
//  Created by Qiwei Li on 7/7/22.
//

import SwiftUI
import CodeEditTextView

struct DocumentForm: View {
    @EnvironmentObject var meilisearchModel: MeilisearchModel
    
    @Binding var isPresented: Bool
    @State var data: String = ""
    @State var loading: Bool = false
    @State var error: Error?
    @State var theme = EditorTheme(text: .init(hex: "#D9D9D9"), insertionPoint: .init(hex: "#D9D9D9"), invisibles: .init(hex: "#424D5B"), background: .init(hex: "#1f2024").withAlphaComponent(0), lineHighlight: .init(hex: "#23252B"), selection: .init(hex: "#D9D9D9"), keywords: .white, commands: .white, types: .systemPink, attributes: .white, variables: .systemIndigo, values: .systemYellow, numbers: .init(hex: "#D0BF69"), strings: .init(hex: "#FC6A5D"), characters: .init(hex: "#D0BF69"), comments: .init(hex: "#73A74E"))
    
    @State var font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
    @State var tabWidth = 4
    @State var lineHeight = 1.2
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if loading {
                    Text("Loading...")
                }
                
                if let error = error {
                    ErrorPopupIcon(error: error)
                }
            }
            
            Text("Document Data")
            CodeEditTextView(
                $data,
                language: .json,
                theme: $theme,
                font: $font,
                tabWidth: $tabWidth,
                lineHeight: $lineHeight
            )
            
            
            HStack {
                Spacer()
                Button("Submit") {
                    Task{
                        await submit()
                    }
                }
                .background(.blue)
            }
        }
        .padding()
        
    }
    
    func submit() async {
        loading = true
        error = nil
        do {
            try await meilisearchModel.addDocument(content: data)
            isPresented = false
        } catch let error {
            self.error = error
        }
        
        loading = false
    }
}
