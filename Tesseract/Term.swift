//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Term {
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
}


public enum Value {
	case Boolean(Swift.Bool)
	case Integer(Swift.Int)
	case String(Swift.String)
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
