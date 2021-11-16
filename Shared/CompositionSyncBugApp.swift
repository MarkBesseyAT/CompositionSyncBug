//
//  CompositionSyncBugApp.swift
//  Shared
//
//  Created by Mark Bessey on 11/10/21.
//

import SwiftUI

@main
struct CompositionSyncBugApp: App {
    let appModel = AppModel()
    init() {
    }
    var body: some Scene {
        WindowGroup {
            ContentView(appModel: appModel)
        }
    }
}
