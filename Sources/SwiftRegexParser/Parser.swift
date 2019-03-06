//
//  Tokenizer.swift
//  SwiftRegex
//
//  Created by Piotr Gorzelany on 02/03/2019.
//

import Foundation

class Parser {
    func parse(input: ArraySlice<Token>) throws -> Expression {
        guard let parseResults = parseExpression(input: input), parseResults.reminder.isEmpty else {
            throw NSError(domain: "parser", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid regex"])
        }
        return parseResults.ast
    }

    private func parseExpression(input: ArraySlice<Token>) -> ParseResult<Expression>? {
        guard let termParseResults = parseTerm(input: input) else {
            return nil
        }

        guard let orSymbolParseResults = parseSymbol(symbol: .or, input: termParseResults.reminder),
            let expressionParseResults = parseExpression(input: orSymbolParseResults.reminder) else {
            return ParseResult(ast: Expression.term(termParseResults.ast), reminder: termParseResults.reminder)
        }

        return ParseResult(ast: Expression.or(termParseResults.ast, expressionParseResults.ast), reminder: expressionParseResults.reminder)
    }

    private func parseTerm(input: ArraySlice<Token>) -> ParseResult<Term>? {
        guard let factorParseResults = parseFactor(input: input) else {
            return nil
        }

        if let termParseResults = parseTerm(input: factorParseResults.reminder) {
            let ast = Term.composite(factorParseResults.ast, termParseResults.ast)
            return ParseResult(ast: ast, reminder: termParseResults.reminder)
        }

        return ParseResult(ast: Term.simple(factorParseResults.ast), reminder: factorParseResults.reminder)
    }

    private func parseFactor(input: ArraySlice<Token>) -> ParseResult<Factor>? {
        guard let atomParseResults = parseAtom(input: input) else {
            return nil
        }

        if let metacharacterParseResults = parseMetacharacter(input: atomParseResults.reminder) {
            let ast = Factor.composite(atomParseResults.ast, metacharacterParseResults.ast)
            return ParseResult(ast: ast, reminder: metacharacterParseResults.reminder)
        }

        return ParseResult(ast: Factor.simple(atomParseResults.ast), reminder: atomParseResults.reminder)
    }

    private func parseAtom(input: ArraySlice<Token>) -> ParseResult<Atom>? {
        if let characterParseResults = parseCharacter(input: input) {
            return ParseResult(ast: Atom.character(characterParseResults.ast), reminder: characterParseResults.reminder)
        } else if let anyParseResults = parseSymbol(symbol: .anyCharacter, input: input) {
            return ParseResult(ast: Atom.any, reminder: anyParseResults.reminder)
        } else if let groupParseResults = parseGroup(input: input) {
            return ParseResult(ast: Atom.group(groupParseResults.ast), reminder: groupParseResults.reminder)
        }

        return nil
    }

    private func parseGroup(input: ArraySlice<Token>) -> ParseResult<Expression>? {
        guard let groupOpenParseResults = parseSymbol(symbol: .groupOpen, input: input),
            let expressionParseResults = parseExpression(input: groupOpenParseResults.reminder),
            let groupCloseParseResults = parseSymbol(symbol: .groupClose, input: expressionParseResults.reminder) else {
                return nil
        }

        return ParseResult(ast: expressionParseResults.ast, reminder: groupCloseParseResults.reminder)
    }

    private func parseCharacter(input: ArraySlice<Token>) -> ParseResult<Character>? {
        guard let first = input.first, case let Token.character(character) = first else {
            return nil
        }

        return ParseResult(ast: character, reminder: input[(input.startIndex + 1)...])
    }

    private func parseSymbol(symbol: Symbol, input: ArraySlice<Token>) -> ParseResult<Symbol>? {
        guard let first = input.first, case let Token.symbol(s) = first, symbol == s else {
            return nil
        }

        return ParseResult(ast: symbol, reminder: input[(input.startIndex + 1)...])
    }

    private func parseMetacharacter(input: ArraySlice<Token>) -> ParseResult<Metacharacter>? {
        guard let first = input.first, case let Token.symbol(symbol) = first, let metacharacter = Metacharacter(rawValue: symbol.rawValue) else {
            return nil
        }

        return ParseResult(ast: metacharacter, reminder: input[(input.startIndex + 1)...])
    }
}
