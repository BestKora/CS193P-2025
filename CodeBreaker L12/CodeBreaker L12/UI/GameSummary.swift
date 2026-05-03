//
//  GameSummary.swift
//  CodeBreaker
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack (alignment: .leading){
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempts](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    .listStyle(.plain)
}

