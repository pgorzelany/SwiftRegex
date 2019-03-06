/*
 Based on https://web.archive.org/web/20090129224504/http://faqts.com/knowledge_base/view.phtml/aid/25718/fid/200
 */

import Foundation

enum AST {
    case expression(Expression)
    case term(Term)
    case factor(Factor)
    case atom(Atom)
    case metacharacter(Metacharacter)
}

indirect enum Expression {
    case term(Term)
    case or(Term, Expression)
}

indirect enum Term {
    case simple(Factor)
    case composite(Factor, Term)
}

enum Factor {
    case simple(Atom)
    case composite(Atom, Metacharacter)
}

enum Atom {
    case character(Character)
    case any
    case group(Expression)
}

enum Metacharacter: String {
    case zeroOrOne = "?"
    case zeroOrMore = "*"
    case oneOrMore = "+"
}
