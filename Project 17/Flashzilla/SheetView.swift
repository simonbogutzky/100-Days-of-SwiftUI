//
//  SheetView.swift
//  Flashzilla
//
//  Created by Simon Bogutzky on 17.12.20.
//

import SwiftUI

enum SheetViewConfiguration {
    case settingsView
    case editCards
}

struct SheetView: View {
    
    var configuration: SheetViewConfiguration
    @ObservedObject var settings: SettingsObject
    
    var body: some View {
        if configuration == .editCards {
            EditCards()
        }
        
        if configuration == .settingsView {
            SettingsView(settings: settings)
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(configuration: .editCards, settings: SettingsObject())
    }
}
