import Foundation

public protocol RegexMatcher {
    func match(input: ArraySlice<Character>) -> RegexMatch?
}

public class EmptyMatcher: RegexMatcher {
    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        return RegexMatch(characters: [], reminder: input)
    }
}

public class CharacterMatcher: RegexMatcher {

    let character: Character

    init(character: Character) {
        self.character = character
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        guard let first = input.first, self.character == first else {
            return nil
        }

        return RegexMatch(characters: [character], reminder: input[input.index(after: input.startIndex)...])
    }
}

public class AnyCharacterMatcher: RegexMatcher {

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        guard let first = input.first else {
            return nil
        }

        return RegexMatch(characters: [first], reminder: input[input.index(after: input.startIndex)...])
    }
}

public class AndMatcher: RegexMatcher {

    public let matchers: [RegexMatcher]

    init(matchers: [RegexMatcher]) {
        self.matchers = matchers
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        var results: [Character] = []
        var reminder = input

        for matcher in matchers {
            guard let match = matcher.match(input: reminder) else {
                return nil
            }
            results += match.characters
            reminder = match.reminder
        }

        return RegexMatch(characters: results, reminder: reminder)
    }
}

public class OrMatcher: RegexMatcher {

    let matchers: [RegexMatcher]

    init(matchers: [RegexMatcher]) {
        self.matchers = matchers
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        return matchers.lazy.compactMap({ $0.match(input: input) }).first
    }
}

public class OneOrMoreMatcher: RegexMatcher {

    let matcher: RegexMatcher

    init(matcher: RegexMatcher) {
        self.matcher = matcher
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        guard let firstMatch = matcher.match(input: input) else {
            return nil
        }

        var results = firstMatch.characters
        var reminder = firstMatch.reminder
        while let match = matcher.match(input: reminder) {
            results += match.characters
            reminder = match.reminder
        }

        return RegexMatch(characters: results, reminder: reminder)
    }
}

public class ZeroOrMoreMatcher: RegexMatcher {

    let matcher: RegexMatcher

    init(matcher: RegexMatcher) {
        self.matcher = matcher
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        return OneOrMoreMatcher(matcher: matcher).match(input: input) ?? EmptyMatcher().match(input: input)
    }
}

public class ZeroOrOneMatcher: RegexMatcher {

    let matcher: RegexMatcher

    init(matcher: RegexMatcher) {
        self.matcher = matcher
    }

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        return matcher.match(input: input) ?? EmptyMatcher().match(input: input)
    }
}
