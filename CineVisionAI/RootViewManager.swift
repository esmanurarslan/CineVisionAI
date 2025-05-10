//
//  RootViewManager.swift
//  CineVisionAI
//
//  Created by Esma Nur Arslan on 10.05.2025.
//

import SwiftUI

class RootViewManager: ObservableObject {
    @Published var rootViewId = UUID()

    func resetToRoot() {
        rootViewId = UUID()
    }
}
