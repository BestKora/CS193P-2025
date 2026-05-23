//
//  CodeBreaker_L15App.swift
//  CodeBreaker L15
//
//  Created by Tatiana Kornilova on 23/05/2026.
//

import SwiftUI
import SwiftData

@main
struct CodeBreaker_L15App: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
            .modelContainer(for: CodeBreaker.self)
        }
    }
}
