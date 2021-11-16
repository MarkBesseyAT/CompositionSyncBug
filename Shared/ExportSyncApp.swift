//
//  ExportSyncApp.swift
//  Shared
//
//  Created by Mark Bessey on 11/10/21.
//

import SwiftUI

@main
struct ExportSyncApp: App {
    let appModel = AppModel()
    init() {
    }
    var body: some Scene {
        WindowGroup {
            ContentView(appModel: appModel)
        }
    }
}
