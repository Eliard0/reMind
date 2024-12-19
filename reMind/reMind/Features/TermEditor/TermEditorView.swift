//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI

struct TermEditorView: View {
    @State var term: String
    @State var meaning: String
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var boxViewModel: BoxViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Term", text: $term)
                reTextEditor(title: "Meaning", text: $meaning)
                
                Spacer()

                Button(action: {
                    boxViewModel.saveTerm(term: term, meaning:  meaning)
                    dismiss()
                }, label: {
                    Text("Save and Add New")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(reButtonStyle())
            }
            .padding()
            .background(reBackground())
            .navigationTitle("New Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("Cancel")
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let mockBox = Box(context: CoreDataStack.inMemory.managedContext)

        let boxViewModel = BoxViewModel(box: mockBox)
        
        TermEditorView(term: "", meaning: "", boxViewModel: boxViewModel) 
    }
}
