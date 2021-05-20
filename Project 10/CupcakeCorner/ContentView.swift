//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Simon Bogutzky on 05.11.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sessionObject = SessionObject()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $sessionObject.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $sessionObject.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(sessionObject.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $sessionObject.order.specialRequestEnabled.animation(), label: {
                        Text("Any special request")
                    })
                    
                    if sessionObject.order.specialRequestEnabled {
                        Toggle(isOn: $sessionObject.order.extraFrosting, label: {
                            Text("Add extra frosting")
                        })
                        
                        Toggle(isOn: $sessionObject.order.addSprinkles, label: {
                            Text("Add extra sprinkles")
                        })
                    }
                }
                
                Section {
                    NavigationLink(
                        destination: AddressView(sessionObject: sessionObject)) {
                            Text("Delivery details")
                        }
                }
            }.navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
