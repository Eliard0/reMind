//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//

import Foundation

class BoxesViewModel: ObservableObject {
    @Published var boxes: [Box] = []

    init() {
        self.boxes = Box.all()
    }

    func getNumberOfPendingTerms(of box: Box) -> String {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count == 0 ? "" : "\(filteredTerms.count)"
    }
    
    func saveBox(name: String, thema: Int, description: String) {
        let context = CoreDataStack.inMemory.managedContext
        
        let box = Box(context: context)
        box.rawTheme = Int16(thema)
        box.name = name
        box.identifier = UUID()
        
        do {
            try context.save()
            self.boxes = Box.all()
        } catch {
            print("Erro ao salvar Box: \(error)")
        }
    }
}
