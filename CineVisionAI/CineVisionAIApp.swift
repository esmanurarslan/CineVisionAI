//
//  CineVisionAIApp.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 21.03.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CineVisionAIApp: App { // Uygulamanızın struct adını kullanın
    @StateObject var rootViewManager = RootViewManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView() // Bu zaten ana NavigationView'ı içeriyor
                .environmentObject(rootViewManager) // ObservableObject'i environment'a ekle
                .id(rootViewManager.rootViewId)      // ID'yi buraya bağla
        }
    }
}
