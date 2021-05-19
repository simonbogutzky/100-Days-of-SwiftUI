//
//  ContentView.swift
//  iExpense
//
//  Created by Simon Bogutzky on 24.10.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)").foregroundColor(item.amount < 10 ? Color.green : item.amount < 100 ? Color.yellow : Color.red).fontWeight(item.amount < 100 ? .regular : .bold)
                    }
                    
                    
                }.onDelete(perform: removeItems(at:))
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "plus")
            }                         
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
