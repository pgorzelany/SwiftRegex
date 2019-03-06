//
//  Compiler.swift
//  swift-regex-core
//
//  Created by Piotr Gorzelany on 26/02/2019.
//

import Foundation
import SwiftRegexParser

public class Regex {

    let regexMatcher: RegexMatcher

    /// Returns a compiled regex if the input is a valid regex
    ///
    /// - Parameter regex: A valid raw regex string
    public init?(regex: String) {
        guard let ast = try? Parser().parse(regexString: regex) else {
            return nil
        }
        regexMatcher = RegexCompiler().compile(ast: ast)
    }

    public func firstMatch(in string: String) -> RegexMatch? {
        let characters = string.map(Character.init)
        for index in characters.indices {
            if let match = regexMatcher.match(input: characters[index...]) {
                return match
            }
        }

        return nil
    }

    public func allMatches(in string: String) -> [RegexMatch] {
        var reminder = string
        var results = [RegexMatch]()
        while let match = firstMatch(in: reminder) {
            reminder = String(match.reminder)
            results.append(match)
        }

        return results
    }

    public func numberOfMatches(in string: String) -> Int {
        return allMatches(in: string).count
    }
}
