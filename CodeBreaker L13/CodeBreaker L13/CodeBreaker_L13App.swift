//
//  CodeBreaker_L13App.swift
//  CodeBreaker L13
//
//  Created by Tatiana Kornilova on 11/05/2026.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
            .modelContainer(for: CodeBreaker.self)
        }
    }
}
