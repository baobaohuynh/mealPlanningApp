//
//  ViewModel.swift
//  FinalProject-version1
//
//  Created by Bao Huynh on 4/18/23.
//

import SwiftUI
import Foundation
import CoreData

class DataModel {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    func addItem(foodTitle: String, foodSum: String, imageLink: String, itemID: Int64) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.title = foodTitle
            newItem.summary = foodSum
            newItem.imageURL = imageLink
            newItem.id = itemID
                        
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}


