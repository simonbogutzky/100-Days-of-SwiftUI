//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Simon Bogutzky on 17.12.20.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings: SettingsObject

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    Toggle("Put wrong cards back", isOn: $settings.putWrongCardsBack)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .navigationViewStyle(StackNavigationViewStyle())
            .listStyle(GroupedListStyle())
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsObject())
    }
}
