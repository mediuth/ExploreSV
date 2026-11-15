//
//  ExploreSVApp.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct ExploreSVApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
