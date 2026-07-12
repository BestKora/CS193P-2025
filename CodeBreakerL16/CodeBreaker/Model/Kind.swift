//
//  Kind.swift
//  CodeBreaker
//
//  Created by ChatGPT on 5/12/25.
//  Prompt: enhance this enum to make it convertible to and from a string: <paste Kind with Match embedded>
//  Followup Prompt: don't use Codable
//  Followup Prompt: make the from function be a non-failable initializer
//

enum Kind: Equatable, CustomStringConvertible {
    case master(isHidden: Bool)
    case guess
    case attempt([Match])
    case unknown

    // MARK: - CustomStringConvertible

    var description: String {
        switch self {
        case .master(let isHidden):
            return "master(\(isHidden))"
        case .guess:
            return "guess"
        case .attempt(let matches):
            let matchStr = matches.map { $0.rawValue }.joined(separator: ",")
            return "attempt(\(matchStr))"
        case .unknown:
            return "unknown"
        }
    }

    // MARK: - Non-Failable Initializer

    init(_ string: String) {
        if string == "guess" {
            self = .guess
            return
        }

        if string == "unknown" {
            self = .unknown
            return
        }

        if string.hasPrefix("master("), string.hasSuffix(")") {
            let inner = String(string.dropFirst("master(".count).dropLast())
            switch inner {
            case "true":
                self = .master(isHidden: true)
                return
            case "false":
                self = .master(isHidden: false)
                return
            default:
                break
            }
        }

        if string.hasPrefix("attempt("), string.hasSuffix(")") {
            let inner = String(string.dropFirst("attempt(".count).dropLast())
            let matchStrings = inner.split(separator: ",").map(String.init)
            let matches = matchStrings.compactMap { Match(rawValue: $0) }
            self = .attempt(matches)
            return
        }

        self = .unknown
    }
}
