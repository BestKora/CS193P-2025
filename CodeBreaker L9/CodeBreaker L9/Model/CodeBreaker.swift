//
//  CodeBreaker.swift
//  CodeBreaker
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    var startTime: Date = Date.now
    var endTime: Date?
    
    init (pegChoices: [Peg] = [.red,.green, .blue, .yellow]) {
      self.pegChoices = pegChoices
      masterCode.randomize(from: pegChoices)
    }
    
    var isOver : Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
    }
    
    mutating func attemptGuess (){
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg (_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else {return}
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices =  pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices [(indexOfExistingPegInPegChoices + 1) %  pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg

        }
    }
    
}


//Peg.missing
/*extension Peg {
    static let missing = Color.clear
}*/
