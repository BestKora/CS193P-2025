//
//  Words.swift
//  CodeBreakerWord
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
        Words(from: commonWordsURL())

    static func commonWordsURL(bundle: Bundle = .main) -> URL? {
        bundle.url(forResource: "common", withExtension: "words")
    }

    static func loadWords(from url: URL) async throws -> [Int: Set<String>] {
        var wordsByLength = [Int: Set<String>]()
        for try await line in url.lines {
            let word = line.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            guard !word.isEmpty else { continue }
            wordsByLength[word.count, default: []].insert(word)
        }
        return wordsByLength
    }

    private init(from url: URL? = nil) {
        Task {
            var _words = [Int:Set<String>]()
            if let url {
                do {
                    _words = try await Self.loadWords(from: url)
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

/*
extension UITextChecker {
    func isAWord(_ word: String) -> Bool {
        rangeOfMisspelledWord(
            in: word,
            range: NSRange(location: 0, length: word.utf16.count),
            startingAt: 0,
            wrap: false,
            language: "en_US"
        ).location == NSNotFound
    }
}
*/
