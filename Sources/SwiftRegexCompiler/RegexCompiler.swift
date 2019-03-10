//
//  RegexCompiler.swift
//  SwiftRegexCompiler
//
//  Created by Piotr Gorzelany on 06/03/2019.
//

import Foundation
import SwiftRegexParser

class RegexCompiler {
    func compile(ast: AST) -> RegexMatcher {
        switch ast {
        case .expression(let expresssion):
            switch expresssion {
            case .term(let term):
                return compile(ast: AST.term(term))
            case .or(let term, let expression):
                let termMatcher = compile(ast: AST.term(term))
                let expressionMatcher = compile(ast: AST.expression(expression))
                return OrMatcher(matchers: [termMatcher, expressionMatcher])
            }
        case .term(let term):
            switch term {
            case .simple(let factor):
                return compile(ast: AST.factor(factor))
            case .composite(let factor, let term):
                let factorMatcher = compile(ast: AST.factor(factor))
                let termMatcher = compile(ast: AST.term(term))
                return AndMatcher(matchers: [factorMatcher, termMatcher])
            }
        case .factor(let factor):
            switch factor {
            case .simple(let atom):
                return compile(ast: AST.atom(atom))
            case .composite(let atom, let metacharacter):
                let atomMatcher = compile(ast: AST.atom(atom))
                switch metacharacter {
                case .oneOrMore:
                    return OneOrMoreMatcher(matcher: atomMatcher)
                case .zeroOrMore:
                    return ZeroOrMoreMatcher(matcher: atomMatcher)
                case .zeroOrOne:
                    return ZeroOrOneMatcher(matcher: atomMatcher)
                }
            }
        case .atom(let atom):
            switch atom {
            case .any:
                return AnyCharacterMatcher()
            case .character(let character):
                return CharacterMatcher(character: character)
            case .group(let expression):
                return compile(ast: AST.expression(expression))
            }
        }
    }
}
