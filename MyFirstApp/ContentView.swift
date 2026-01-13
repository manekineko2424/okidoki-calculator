//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Ohku takuya on 2026/01/13.
//

import SwiftUI

struct ContentView: View {
    @State private var isTapped = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(isTapped ? "Button tapped!" : "Hello, MyFirstApp!")
            Button("Toggle text") {
                isTapped.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
