//
//  Tokenizer.swift
//  SwiftRegex
//
//  Created by Piotr Gorzelany on 02/03/2019.
//

import Foundation

class Tokenizer {
    public func getAllTokens(input: String) -> [Token] {
        var tokens: [Token] = []
        var currentIndex = input.startIndex
        repeat {
            var nextIndex = input.index(after: currentIndex)
            let character = input[currentIndex]
            if let symbol = Symbol(rawValue: String(character)) {
                if symbol == .escape {
                    // We need to look ahead to get the escaped character
                    guard currentIndex < input.endIndex else {
                        continue
                    }
                    tokens.append(Token.character(input[nextIndex]))
                    nextIndex = input.index(after: nextIndex)
                } else {
                    tokens.append(Token.symbol(symbol))
                }
            } else {
                tokens.append(Token.character(character))
            }
            currentIndex = nextIndex
        } while currentIndex < input.endIndex
        return tokens
    }
}
