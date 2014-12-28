//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Term: Printable {
	// MARK: Constructors

	public static func abstraction(type: Type, _ body: Term) -> Term {
		return Abstraction(type, Box(body))
	}


	// MARK: Base

	case Constant(Value)


	// MARK: λ

	case Variable(Int) // de Bruijn index
	case Abstraction(Type, Box<Term>)
	case Application(Box<Term>, Box<Term>)


	// MARK: Printable

	public var description: String {
		switch self {
		case let .Constant(v):
			return toString(v)
		case let .Variable(i):
			return toString(i)
		case let .Abstraction(t, body):
			return "λ \(t) . \(body)"
		case let .Application(t1, t2):
			return "(\(t1) \(t2))"
		}
	}
}


public enum Value: Printable {
	case Boolean(Swift.Bool)
	case Integer(Swift.Int)
	case String(Swift.String)

	public var description: Swift.String {
		switch self {
		case let .Boolean(v):
			return v ? "true" : "false"
		case let .Integer(x):
			return toString(x)
		case let .String(s):
			return "\"\(s)\""
		}
	}
}


func shift(term: Term, by: Int, above: Int = 0) -> Term {
	return map(term, above) { above, n in
		.Variable(n + n >= above ? by : 0)
	}
}


func substitute(term: Term, inTerm: Term) -> Term {
	return shift(substitute(shift(term, 1), 0, inTerm), -1)
}

func substitute(term: Term, forIndex: Int, inTerm: Term) -> Term {
	return map(inTerm, forIndex) { index, n in
		n == index ? shift(term, index) : .Variable(n)
	}
}

func map(term: Term, c: Int, f: (Int, Int) -> Term) -> Term {
	let walk: (Term, Int) -> Term = fix { walk in
		{ term, c in
			switch term {
			case .Constant:
				return term

			case let .Variable(n):
				return f(c, n)
			case let .Abstraction(type, body):
				return .Abstraction(type, body.map { walk($0, c + 1) })
			case let .Application(a, b):
				return .Application(a.map { walk($0, c) }, b.map { walk($0, c) })
			}
		}
	}
	return walk(term, c)
}


public func eval(term: Term) -> Value? {
	switch term {
	case let .Constant(value):
		return value

	default:
		return nil
	}
}


// MARK: - Imports

import Box
import Prelude
