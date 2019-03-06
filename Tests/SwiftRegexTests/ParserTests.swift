//
//  ParserTests.swift
//  SwiftRegexTests
//
//  Created by Piotr Gorzelany on 06/03/2019.
//

import XCTest
@testable import SwiftRegexParser

class ParserTests: XCTestCase {

    var tokenizer = Tokenizer()
    var parser = Parser()

    func testComplexRegexParsing() {
        let regexString = "a.?b*(cdfg)|ab*|(d?fg|(wow+))"
        let tokens = tokenizer.getAllTokens(input: regexString)
        guard let ast = try? parser.parse(input: tokens[...]) else {
            XCTAssert(false)
            return
        }
        let prettyPrinter = ASTPrinter()
        prettyPrinter.prettyPrint(ast: AST.expression(ast))
    }
}
