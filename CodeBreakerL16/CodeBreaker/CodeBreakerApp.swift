//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 3/31/25.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                GameChooser()
                    .modelContainer(for: CodeBreaker.self)
                    .environment(\.sceneFrame, geometry.frame(in: .global))
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
