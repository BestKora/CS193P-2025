//
//  Words.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var words = Words.shared
}

@Observable
class Words {
    private var words = Dictionary<Int, Set<String>>()
    
    static let shared =
        Words(from: URL(string: "https://web.stanford.edu/class/cs193p/common.words"))

    private init(from url: URL? = nil) {
        Task {
            var _words = [Int:Set<String>]()
            if let url {
                do {
                    for try await word in url.lines {
                        _words[word.count, default: Set<String>()].insert(word.uppercased())
                    }
                } catch {
                    print("Words could not load words from \(url): \(error)")
                }
            }
            words = _words
            if count > 0 {
                print("Words loaded \(count) words from \(url?.absoluteString ?? "nil")")
            }
        }
    }
    
    var count: Int {
        words.values.reduce(0) { $0 + $1.count }
    }
    
    func contains(_ word: String) -> Bool {
        words[word.count]?.contains(word.uppercased()) == true
    }

    func random(length: Int) -> String? {
        let word = words[length]?.randomElement()
        if word == nil {
            print("Words could not find a random word of length \(length)")
        }
        return word
    }
}
