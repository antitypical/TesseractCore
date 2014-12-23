//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Term {
	case Parameter(String, Type)
	case Return(String, Type)

	case Constant(Value)

	case Variable(Int)
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
