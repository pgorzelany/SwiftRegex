//
//  ParseMatch.swift
//  swift-regex-parser
//
//  Created by Piotr Gorzelany on 02/03/2019.
//

import Foundation

struct ParseResult<T> {
    let ast: T
    let reminder: ArraySlice<Token>

    init(ast: T, reminder: ArraySlice<Token>) {
        self.ast = ast
        self.reminder = reminder
    }
}
