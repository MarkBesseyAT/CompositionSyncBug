//
//  AppModel.swift
//  CompositionSyncBug
//
//  Created by Mark Bessey on 11/15/21.
//

import Foundation
import Combine

class AppModel: ObservableObject {
    @Published var firstMovie:URL = Bundle.main.url(forResource: "FiveMinutes48KHz", withExtension: "mov")!
    @Published var secondMovie:URL = Bundle.main.url(forResource: "OneMinute16KHz", withExtension: "mov")!
    @Published var destination = FileManager.default.temporaryDirectory.appendingPathComponent("destination.mov")
}
