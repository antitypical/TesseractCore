//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Term: Printable, Equatable {
	// MARK: Constructors

	public static func abstraction(type: Type, _ body: Term) -> Term {
		return Abstraction(type, Box(body))
	}

	public static func application(abstraction: Term, _ operand: Term) -> Term {
		return Application(Box(abstraction), Box(operand))
	}


	// MARK: Base

	case Constant(Value)


	// MARK: λ

	case Variable(Int) // de Bruijn index
	case Abstraction(Type, Box<Term>)
	case Application(Box<Term>, Box<Term>)


	// MARK: Destructuring

	public func destructure() -> DestructuredTerm {
		switch self {
		case let Constant(v):
			return .Constant(v)
		case let Variable(i):
			return .Variable(i)
		case let Abstraction(type, body):
			return .Abstraction(type, body.value)
		case let Application(t1, t2):
			return .Application(t1.value, t2.value)
		}
	}


	// MARK: Values

	var isValue: Bool {
		switch self {
		case Constant, Abstraction:
			return true
		default:
			return false
		}
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Constant(v):
			return toString(v)
		case let Variable(i):
			return toString(i)
		case let Abstraction(t, body):
			return "λ \(t) . \(body)"
		case let Application(t1, t2):
			return "(\(t1) \(t2))"
		}
	}
}

public enum DestructuredTerm {
	case Constant(Value)

	case Variable(Int)
	case Abstraction(Type, Term)
	case Application(Term, Term)
}


public enum Value: Printable, Equatable {
	case Unit
	case Boolean(Swift.Bool)
	case Integer(Swift.Int)
	case String(Swift.String)

	public var description: Swift.String {
		switch self {
		case let Boolean(v):
			return v ? "true" : "false"
		case let Integer(x):
			return toString(x)
		case let String(s):
			return "\"\(s)\""
		}
	}
}

public func == (left: Value, right: Value) -> Bool {
	switch (left, right) {
	case let (.Boolean(x), .Boolean(y)) where x == y:
		return true
	case let (.Integer(x), .Integer(y)) where x == y:
		return true
	case let (.String(x), .String(y)) where x == y:
		return true

	default: return false
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

func evalStep(term: Term) -> Either<Term, Term> {
	switch term.destructure() {
	case let .Application(.Abstraction(_, body), operand) where operand.isValue:
		return .right(substitute(operand, body.value))
	case let .Application(a, b) where a.isValue:
		return evalStep(b).map { .Application(Box(a), Box($0)) }
	case let .Application(a, b):
		return evalStep(a).map { .Application(Box($0), Box(b)) }

	default:
		return .left(term)
	}
}

public func eval(term: Term) -> Term {
	return evalStep(term).either(id, { eval($0) })
}


public func == (left: Term, right: Term) -> Bool {
	switch (left.destructure(), right.destructure()) {
	case let (.Constant(x), .Constant(y)) where x == y:
		return true

	// fixme: this is insufficient, we need to know the context
	case let (.Variable(x), .Variable(y)) where x == y:
		return true
	case let (.Abstraction(leftType, leftBody), .Abstraction(rightType, rightBody)) where leftType == rightType && leftBody == rightBody:
		return true
	case let (.Application(left1, left2), .Application(right1, right2)) where left1 == right1 && left2 == right2:
		return true

	default:
		return false
	}
}


// MARK: - Imports

import Box
import Either
import Prelude
