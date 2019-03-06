//
//  ASTPrinter.swift
//  SwiftRegexParser
//
//  Created by Piotr Gorzelany on 06/03/2019.
//

import Foundation

class ASTPrinter {
    func prettyPrint(ast: AST) {
        prettyPrint(ast: ast, indentationLevel: 0)
    }

    private func prettyPrint(ast: AST, indentationLevel: Int) {
        switch ast {
        case .expression(let expression):
            print("\(createIndentation(level: indentationLevel))Expression:")
            switch expression {
            case .term(let term):
                prettyPrint(ast: AST.term(term), indentationLevel: indentationLevel + 1)
            case .or(let term, let expression):
                prettyPrint(ast: AST.term(term), indentationLevel: indentationLevel + 1)
                prettyPrint(ast: AST.expression(expression), indentationLevel: indentationLevel + 1)
            }
        case .term(let term):
            print("\(createIndentation(level: indentationLevel))Term:")
            switch term {
            case .simple(let factor):
                prettyPrint(ast: AST.factor(factor), indentationLevel: indentationLevel + 1)
            case .composite(let factor, let term):
                prettyPrint(ast: AST.factor(factor), indentationLevel: indentationLevel + 1)
                prettyPrint(ast: AST.term(term), indentationLevel: indentationLevel + 1)
            }
        case .factor(let factor):
            print("\(createIndentation(level: indentationLevel))Factor:")
            switch factor {
            case .simple(let atom):
                prettyPrint(ast: AST.atom(atom), indentationLevel: indentationLevel + 1)
            case .composite(let atom, let metacharcter):
                prettyPrint(ast: AST.atom(atom), indentationLevel: indentationLevel + 1)
                prettyPrint(ast: AST.metacharacter(metacharcter), indentationLevel: indentationLevel + 1)
            }
        case .atom(let atom):
            print("\(createIndentation(level: indentationLevel))Atom:")
            switch atom {
            case .any:
                print("\(createIndentation(level: indentationLevel)).")
            case .character(let character):
                print("\(createIndentation(level: indentationLevel))\(character)")
            case .group(let expression):
                prettyPrint(ast: AST.expression(expression), indentationLevel: indentationLevel + 1)
            }
        case .metacharacter(let metacharacter):
            print("\(createIndentation(level: indentationLevel))Metacharacter: \(metacharacter.rawValue)")
        }
    }

    private func createIndentation(level: Int) -> String {
        return (0...level).map({_ in return "\t"}).joined()
    }
}
