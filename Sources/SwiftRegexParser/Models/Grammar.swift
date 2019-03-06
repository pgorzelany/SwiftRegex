/*
 Based on https://web.archive.org/web/20090129224504/http://faqts.com/knowledge_base/view.phtml/aid/25718/fid/200
 */

import Foundation

public enum AST {
    case expression(Expression)
    case term(Term)
    case factor(Factor)
    case atom(Atom)
}

public indirect enum Expression {
    case term(Term)
    case or(Term, Expression)
}

public indirect enum Term {
    case simple(Factor)
    case composite(Factor, Term)
}

public enum Factor {
    case simple(Atom)
    case composite(Atom, Metacharacter)
}

public enum Atom {
    case character(Character)
    case any
    case group(Expression)
}

public enum Metacharacter: String {
    case zeroOrOne = "?"
    case zeroOrMore = "*"
    case oneOrMore = "+"
}
