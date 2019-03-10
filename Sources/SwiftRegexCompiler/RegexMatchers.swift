import Foundation

protocol RegexMatcher {
    func match(input: ArraySlice<Character>) -> RegexMatch?
}

struct EmptyMatcher: RegexMatcher {
    func match(input: ArraySlice<Character>) -> RegexMatch? {
        return RegexMatch(characters: [], reminder: input)
    }
}

struct CharacterMatcher: RegexMatcher {

    let character: Character

    func match(input: ArraySlice<Character>) -> RegexMatch? {
        guard let first = input.first, self.character == first else {
            return nil
        }

        return RegexMatch(characters: [character], reminder: input[input.index(after: input.startIndex)...])
    }
}

class AnyCharacterMatcher: RegexMatcher {

    public func match(input: ArraySlice<Character>) -> RegexMatch? {
        guard let first = input.first else {
            return nil
        }

        return RegexMatch(characters: [first], reminder: input[input.index(after: input.startIndex)...])
    }
}

struct AndMatcher: RegexMatcher {

    let matchers: [RegexMatcher]

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

struct OrMatcher: RegexMatcher {

    let matchers: [RegexMatcher]

    func match(input: ArraySlice<Character>) -> RegexMatch? {
        return matchers.lazy.compactMap({ $0.match(input: input) }).first
    }
}

struct OneOrMoreMatcher: RegexMatcher {

    let matcher: RegexMatcher

    func match(input: ArraySlice<Character>) -> RegexMatch? {
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

struct ZeroOrMoreMatcher: RegexMatcher {

    let matcher: RegexMatcher

    func match(input: ArraySlice<Character>) -> RegexMatch? {
        return OneOrMoreMatcher(matcher: matcher).match(input: input) ?? EmptyMatcher().match(input: input)
    }
}

struct ZeroOrOneMatcher: RegexMatcher {

    let matcher: RegexMatcher

    func match(input: ArraySlice<Character>) -> RegexMatch? {
        return matcher.match(input: input) ?? EmptyMatcher().match(input: input)
    }
}
