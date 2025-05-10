//
//  CineVisionAIApp.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI

@main
struct CineVisionAIApp: App { // Uygulamanızın struct adını kullanın
    @StateObject var rootViewManager = RootViewManager()

    var body: some Scene {
        WindowGroup {
            ContentView() // Bu zaten ana NavigationView'ı içeriyor
                .environmentObject(rootViewManager) // ObservableObject'i environment'a ekle
                .id(rootViewManager.rootViewId)      // ID'yi buraya bağla
        }
    }
}
