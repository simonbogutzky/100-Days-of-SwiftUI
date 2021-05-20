//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Simon Bogutzky on 06.11.20.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var sessionObject: SessionObject
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $sessionObject.order.name)
                TextField("Street Address", text: $sessionObject.order.streetAddress)
                TextField("City", text: $sessionObject.order.city)
                TextField("Zip", text: $sessionObject.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(sessionObject: sessionObject)) {
                    Text("Check out")
                }
            }
            .disabled(sessionObject.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(sessionObject: SessionObject())
    }
}
