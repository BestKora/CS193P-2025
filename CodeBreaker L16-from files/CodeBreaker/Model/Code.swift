//
//  Code.swift
//  CodeBreaker


import Foundation
import SwiftData

@Model final class Code  {
   var _kind: String = "unknown"
    var pegs: [Peg] = []
    var timestamp = Date.now
    var game: CodeBreaker?
    
   var kind: Kind {
        get { return Kind(_kind)}
        set {  _kind = newValue.description}
    }
    
    init () {  }
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)) {
        self.pegs = pegs
        self.kind = kind
    }
    
    static let missingPeg: Peg = ""
    
   func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
        print(self)
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 4)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        let exactMatches = Array (backwardsExactMatches.reversed())
        
        return  pegs.indices.map { index in
            if exactMatches [index] != .exact,
               let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}

enum Match: String {
    case nomatch
    case exact
    case inexact
}
