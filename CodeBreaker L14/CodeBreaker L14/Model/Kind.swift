//
//  Kind.swift
//  CodeBreaker
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
 
/*
 // Another version from ChatGPT, more compact
 
enum Kind: Equatable, CustomStringConvertible{
    case master(isHidden: Bool)
    case guess
    case attempt([Match])
    case unknown

    init(_ string: String) {
        if string == "guess" {
            self = .guess
            return
        }

        if string == "unknown" {
            self = .unknown
            return
        }

        if string.hasPrefix("master:") {
            let value = String(string.dropFirst(7))
            self = .master(isHidden: Bool(value) ?? false)
            return
        }

        if string.hasPrefix("attempt:") {
            let raw = String(string.dropFirst(8))

            let matches = raw
                .split(separator: ",")
                .compactMap { Match(rawValue: String($0)) }

            self = .attempt(matches)
            return
        }

        self = .unknown
    }

    var description: String {
        switch self {
        case .guess:
            return "guess"

        case .unknown:
            return "unknown"

        case .master(let isHidden):
            return "master:\(isHidden)"

        case .attempt(let matches):
            return "attempt:\(matches.map(\.rawValue).joined(separator: ","))"
        }
    }
}
*/
