//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Ohku takuya on 2026/01/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, MyFirstApp!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
