//
//  CodeBreakerView.swift
//  CodeBreaker

import SwiftUI

struct CodeBreakerView: View {
    @State var game =  CodeBreaker(pegChoices: [.brown,.yellow, .orange, .black])
    
    var body: some View {
        VStack {
            view (for: game.masterCode)
            ScrollView {
                view (for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view (for: game.attempts[index])
                }
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button ("Guess"){
            withAnimation{
                game.attemptGuess()
            }
        }
        .font(.system (size:80) )
        .minimumScaleFactor(0.1)
    }
    
    func view (for code: Code) -> some View {
        HStack {
            ForEach (code.pegs.indices, id: \.self ) {index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missingPeg {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            
            Rectangle().foregroundStyle(Color.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers (matches: matches)
                    } else {
                        if  code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}

