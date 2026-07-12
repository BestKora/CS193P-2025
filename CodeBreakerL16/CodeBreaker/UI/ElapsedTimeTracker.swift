//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 5/21/25.
//

import SwiftUI
import SwiftData

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    let game: CodeBreaker
    
    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: ModelContext.willSave,
            object: modelContext
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
            .onReceive(modelContextWillSavePublisher) { _ in
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
}

