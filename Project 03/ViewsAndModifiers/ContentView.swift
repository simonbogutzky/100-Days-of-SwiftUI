//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Simon Bogutzky on 12.10.20.
//

import SwiftUI

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .foregroundColor(.blue)
    }
}

extension View {
    func blueTitled() -> some View {
        self.modifier(BlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .blueTitled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
