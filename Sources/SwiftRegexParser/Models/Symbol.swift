//
//  Symbol.swift
//  swift-regex-parser
//
//  Created by Piotr Gorzelany on 02/03/2019.
//

import Foundation

enum Symbol: String {
    case oneOreMore = "+"
    case zeroOrMore = "*"
    case zeroOrOne = "?"
    case or = "|"
    case groupOpen = "("
    case groupClose = ")"
    case escape = "\\"
    case anyCharacter = "."
}
