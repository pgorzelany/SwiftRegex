//
//  RegexTests.swift
//  SwiftRegexTests
//
//  Created by Piotr Gorzelany on 06/03/2019.
//

import XCTest
import SwiftRegexCompiler

class RegexTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testZeroOrOneRegex() {
        let regexString = "a?bcd?"
        if let regex = Regex(regex: regexString) {
            let validInputs = ["bcd", "bc", "abc", "abcd", "xbca"]
            let invalidInputs = ["abd", "", "x"]

            for validInput in validInputs {
                let match = regex.firstMatch(in: validInput)
                XCTAssert(match != nil)
            }

            for invalidInput in invalidInputs {
                let match = regex.firstMatch(in: invalidInput)
                XCTAssert(match == nil)
            }
        } else {
            XCTAssert(false)
        }
    }

    func testComplexRegex() {
        let regexString = "ab*|(d?fg|(wow+))"
        if let regex = Regex(regex: regexString) {
            var inputString = "ab"
            var expectedMatch = "ab".map(Character.init)
            var match = regex.firstMatch(in: inputString)
            XCTAssert(match?.characters == expectedMatch, "Match should equal expected match. Is: \(String(describing: match?.characters))")

            inputString = "xwowwwwow"
            expectedMatch = "wowwww".map(Character.init)
            match = regex.firstMatch(in: inputString)
            XCTAssert(match?.characters == expectedMatch, "Match should equal expected match. Is: \(String(describing: match?.characters))")

            inputString = "dddfgwow"
            expectedMatch = "dfg".map(Character.init)
            match = regex.firstMatch(in: inputString)
            XCTAssert(match?.characters == expectedMatch, "Match should equal expected match. Is: \(String(describing: match?.characters))")
        } else {
            XCTAssert(false)
        }
    }

    func testNotMatchingInputPoorPerformanceExample() {
        // Poor performing regex taken from ICU
        // http://userguide.icu-project.org/strings/regexp#TOC-Performance-Tips
        let prefix = String((0...100).map({ _ in return Character("A") }))
        let inputString = "\(prefix)C"
        let regexString = "(A+)+B"
        guard let regex = Regex(regex: regexString) else {
            XCTAssert(false)
            return
        }
        self.measure {
            let match = regex.firstMatch(in: inputString)
            XCTAssert(match == nil)
        }
    }

    func testMatchingInputPoorPerformanceExample() {
        // Poor performing regex taken from ICU
        // http://userguide.icu-project.org/strings/regexp#TOC-Performance-Tips
        let prefix = String((0...100).map({ _ in return Character("A") }))
        let inputString = "\(prefix)B"
        let regexString = "(A+)+B"
        guard let regex = Regex(regex: regexString) else {
            XCTAssert(false)
            return
        }
        self.measure {
            let match = regex.firstMatch(in: inputString)
            XCTAssert(match != nil)
        }
    }
}
