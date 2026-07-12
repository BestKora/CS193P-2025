//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var size: Size = .large
    
    enum Size {
        case compact
        case regular
        case large
        
        var larger: Size {
            switch self {
            case .compact: .regular
            default: .large
            }
        }
        
        var smaller: Size {
            switch self {
            case .large: .regular
            default: .compact
            }
        }
    }
    
    var body: some View {
        let layout = size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))
        layout {
            Text(game.name).font(size == .compact ? .body : .title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: size == .compact ? 35 : 50)
            if size == .large {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    .listStyle(.plain)
}
