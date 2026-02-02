//
//  MyFirstAppApp.swift
//  MyFirstApp
//
//  Created by Ohku takuya on 2026/01/13.
//

import SwiftUI

@main
struct MyFirstAppApp: App {
    init() {
        // AdMob SDKを初期化
        AdMobManager.shared.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
