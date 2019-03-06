//
//  Match.swift
//  swift-regex-core
//
//  Created by Piotr Gorzelany on 25/02/2019.
//

import Foundation

public struct RegexMatch {
    public let characters: [Character]
    public let reminder: ArraySlice<Character>

    init(characters: [Character], reminder: ArraySlice<Character>) {
        self.characters = characters
        self.reminder = reminder
    }
}
