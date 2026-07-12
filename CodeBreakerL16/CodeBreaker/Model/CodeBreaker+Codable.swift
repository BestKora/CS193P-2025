//
//  CodeBreaker+Codable.swift
//  CodeBreaker
//
//  Created by ChatGPT on 5/28/25.
//

import Foundation

extension CodeBreaker: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case masterCode
        case guess
        case _attempts
        case pegChoices
        case startTime
        case endTime
        case elapsedTime
        case lastAttemptDate
        case isOver
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init() // Temporary initialization; override below
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.masterCode = try container.decode(Code.self, forKey: .masterCode)
        self.guess = try container.decode(Code.self, forKey: .guess)
        self._attempts = try container.decode([Code].self, forKey: ._attempts)
        self.pegChoices = try container.decode([Peg].self, forKey: .pegChoices)
        self.startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        self.endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        self.elapsedTime = try container.decode(TimeInterval.self, forKey: .elapsedTime)
        self.lastAttemptDate = try container.decodeIfPresent(Date.self, forKey: .lastAttemptDate)
        self.isOver = try container.decode(Bool.self, forKey: .isOver)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(masterCode, forKey: .masterCode)
        try container.encode(guess, forKey: .guess)
        try container.encode(_attempts, forKey: ._attempts)
        try container.encode(pegChoices, forKey: .pegChoices)
        try container.encodeIfPresent(startTime, forKey: .startTime)
        try container.encodeIfPresent(endTime, forKey: .endTime)
        try container.encode(elapsedTime, forKey: .elapsedTime)
        try container.encodeIfPresent(lastAttemptDate, forKey: .lastAttemptDate)
        try container.encode(isOver, forKey: .isOver)
    }
}

extension Code: Codable {
    enum CodingKeys: String, CodingKey {
        case _kind
        case pegs
        case timestamp
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init() // Default init required for SwiftData models
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._kind = try container.decode(String.self, forKey: ._kind)
        self.pegs = try container.decode([Peg].self, forKey: .pegs)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_kind, forKey: ._kind)
        try container.encode(pegs, forKey: .pegs)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
