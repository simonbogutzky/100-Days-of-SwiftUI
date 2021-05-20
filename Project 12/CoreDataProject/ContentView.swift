//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Simon Bogutzky on 13.11.20.
//

import SwiftUI
import CoreData

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var universeFilter = "Trek"

    var body: some View {
        VStack {
            FilteredList(filterKey: "name", filterValue: universeFilter, filterStingParameter: .beginWith) { (ship: Ship) in
                Text("\(ship.name!) \(ship.universe!)")
            }
            

            Button("Add Examples") {
                let ship1 = Ship(context: self.moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: self.moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: self.moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: self.moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? self.moc.save()
            }
            
            Button("Show E") {
                    self.universeFilter = "E"
                }

            Button("Show M") {
                self.universeFilter = "M"
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
