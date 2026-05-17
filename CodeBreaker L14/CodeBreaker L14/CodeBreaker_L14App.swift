//
//  CodeBreaker_L14App.swift
//  CodeBreaker L14
//
//  Created by Tatiana Kornilova on 17/05/2026.
//

import SwiftUI
import SwiftData

@main
struct CodeBreaker_L14App: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
            .modelContainer(for: CodeBreaker.self)
        }
    }
}
