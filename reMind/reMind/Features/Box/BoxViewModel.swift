//
//  BoxViewModel.swift
//  reMind
//
//  Created by Eliardo Venancio on 19/12/24.
//
import Foundation
import SwiftUI

class BoxViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var filteredTermss: [Term] = []
    private var box: Box
    
    init(box: Box) {
        self.box = box
    }
    
    let context = CoreDataStack.inMemory.managedContext
    
    func saveTerm(term: String, meaning: String ) {
        
        let newTerm = Term(context: context)
        newTerm.identifier = UUID()
        newTerm.value = term
        newTerm.meaning = meaning
        newTerm.creationDate = Date()
        newTerm.lastReview = nil
        newTerm.rawSRS = 0
        newTerm.rawTheme = 0
        
        do {
            try context.save()
            box.addToTerms(newTerm)
            self.filteredTermss.append(newTerm)
            print("Term saved successfully")
        } catch {
            print("Error saving term: \(error.localizedDescription)")
        }
    }
    
    var filteredTerms: [Term] {
        let termsSet = box.terms as? Set<Term> ?? []
        let terms = Array(termsSet).sorted { ($0.value ?? "") < ($1.value ?? "") }
        
        if searchText.isEmpty {
            return terms
        } else {
            return terms.filter { ($0.value ?? "").contains(searchText) }
        }
    }
    
    func deleteTerm(_ term: Term) {
        guard let context = term.managedObjectContext else { return }
        context.delete(term)
        do {
            try context.save()
        } catch {
            print("Error deleting term: \(error)")
        }
    }
}
