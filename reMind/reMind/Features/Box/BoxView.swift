//
//  BoxView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct BoxView: View {
    var box: Box
    
    @State private var searchText: String = ""
    @State private var isCreatedNewTerm: Bool = false
    
    @ObservedObject var viewModel: BoxViewModel
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                print("edit")
            } label: {
                Image(systemName: "square.and.pencil")
            }
            
            Button {
                isCreatedNewTerm.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    private var allCardsSection: some View {
        Section {
            ForEach(viewModel.filteredTerms, id: \.self) { term in
                Text(term.value ?? "Unknown")
                    .padding(.vertical, 8)
                    .fontWeight(.bold)
                    .swipeActions(edge: .trailing) {
                        deleteButton(for: term)
                    }
            }
        } header: {
            Text("All Cards")
                .textCase(.none)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Palette.label.render)
                .padding(.leading, -16)
                .padding(.bottom, 16)
        }
    }
    
    private var todaysCardsSection: some View {
        TodaysCardsView(numberOfPendingCards: box.numberOfTerms, theme: box.theme)
    }
    
    private func deleteButton(for term: Term) -> some View {
        Button(role: .destructive) {
            
        } label: {
            Image(systemName: "trash")
        }
    }
    
    var body: some View {
        List {
            todaysCardsSection
            allCardsSection
            
        }
        .scrollContentBackground(.hidden)
        .background(reBackground())
        .navigationTitle(box.name ?? "Unknown")
        .searchable(text: $searchText, prompt: "")
        .toolbar { toolbarContent }
        .sheet(isPresented: $isCreatedNewTerm) {
            TermEditorView(term: "", meaning: "", boxViewModel: viewModel)
        }
    }
    
    struct BoxView_Previews: PreviewProvider {
        static let box: Box = {
            let box = Box(context: CoreDataStack.inMemory.managedContext)
            box.name = "Box 1"
            box.rawTheme = 0
            BoxView_Previews.terms.forEach { term in
                box.addToTerms(term)
            }
            return box
        }()
        
        static let terms: [Term] = {
            let term1 = Term(context: CoreDataStack.inMemory.managedContext)
            term1.value = "Term 1"
            
            let term2 = Term(context: CoreDataStack.inMemory.managedContext)
            term2.value = "Term 2"
            
            let term3 = Term(context: CoreDataStack.inMemory.managedContext)
            term3.value = "Term 3"
            
            return [term1, term2, term3]
        }()
        
        static var previews: some View {
            NavigationStack {
                BoxView(box: BoxView_Previews.box, viewModel: BoxViewModel(box: box))
            }
        }
    }
}
