//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Simon Bogutzky on 15.11.20.
//

import Foundation
import CoreData
import SwiftUI

enum FetchRequestStringParameter {
    case containsCaseSensitive
    case contains
    case beginWithCaseSensitive
    case beginWith
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var ships: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { ship in
            self.content(ship)
        }
    }

    init(filterKey: String, filterValue: String, filterStingParameter: FetchRequestStringParameter = FetchRequestStringParameter.contains, @ViewBuilder content: @escaping (T) -> Content) {
        var stringParameter = "CONTAINS[c]"
        
        switch filterStingParameter {
        case .beginWith:
            stringParameter = "BEGINSWITH[c]"
        case .beginWithCaseSensitive:
            stringParameter = "BEGINSWITH"
        case .containsCaseSensitive:
            stringParameter = "CONTAINS[c]"
        default:
            stringParameter = "CONTAINS[c]"
        }
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K \(stringParameter) %@", filterKey, filterValue))
        self.content = content
    }
}
