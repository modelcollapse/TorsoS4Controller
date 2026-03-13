//
//  ContentView.swift
//  Torso S4 Controller
//
//  Deprecated - Use MainView instead
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        MainView()
            .environmentObject(appState)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
