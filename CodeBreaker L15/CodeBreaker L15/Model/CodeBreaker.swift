//
//  CodeBreaker.swift
//  CodeBreaker
//

import Foundation
import SwiftData

typealias Peg = String

@Model  class CodeBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code =
                                         Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var pegChoices: [Peg]
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver : Bool = false
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    init (name: String = "Code Breaker", pegChoices: [Peg]) {
      self.name = name
      self.pegChoices = pegChoices
      masterCode.randomize(from: pegChoices)
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }

    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attemptGuess (){
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset()
        
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }
    }
 
    func setGuessPeg (_ peg: Peg, at index: Int) {
         guard guess.pegs.indices.contains(index) else {return}
         guess.pegs[index] = peg
     }
}

