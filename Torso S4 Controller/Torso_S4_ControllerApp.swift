//
//  Torso_S4_ControllerApp.swift
//  Torso S4 Controller
//
//  Created by Bryan Abdul Collins on 3/13/26.
//

import SwiftUI

@main
struct Torso_S4_ControllerApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .frame(minWidth: 1280, minHeight: 800)
        }
    }
}
