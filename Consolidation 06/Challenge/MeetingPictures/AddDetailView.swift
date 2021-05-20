//
//  AddDetailView.swift
//  MeetingPictures
//
//  Created by Simon Bogutzky on 05.12.20.
//

import SwiftUI

struct AddDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String?
    @State var inputName: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $inputName)
                }

                Section {
                    Button(action: {
                        name = inputName
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
                .disabled(inputName.isEmpty)
            }.navigationBarTitle(Text("Add details"), displayMode: .inline)
        }
    }
}

struct AddDetailView_Previews: PreviewProvider {
    static var name: String = "Flowers"

    static var previews: some View {
        AddDetailView(name: .constant(name))
    }
}
