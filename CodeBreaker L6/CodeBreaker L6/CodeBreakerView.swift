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
            view (for: game.masterCode)
            ScrollView {
                if !game.isOver {
                    view (for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view (for: game.attempts[index])
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
            print ("random word = \(words.random(length: 5) ?? "none")")
        }
        .font(.system (size:GuessButton.maximumFontSize) )
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    func view (for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
            Color.clear.foregroundStyle(Color.clear)
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

