//
//  CodeBreakerView.swift
//  CodeBreaker

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words

    //MARK: Data Owned By Me
    @State private var game =  CodeBreaker(pegChoices:
                            [.brown,.yellow, .orange, .black, .green])
    @State private var selection: Int = 0
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            CodeView (code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView (code: game.guess, selection: $selection){
                        guessButton
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView (code: game.attempts[index]){
                        if let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                }
            }
            PegChooser(choices: game.pegChoices) {peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
    }

    var guessButton: some View {
        Button ("Guess"){
            withAnimation{
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system (size:GuessButton.maximumFontSize) )
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
}

extension Color {
    static func gray(_ brightness: CGFloat)-> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}

