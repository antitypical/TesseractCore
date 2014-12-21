//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Type {
	case Boolean
	case Integer
	case String

	case Function(Box<Type>, Box<Type>)

	case Generic(Int, Box<Type>)
	case Parameter(Int)

	case Sum([Type])
	case Product([Type])
}


public func typeof(term: Term) -> Type {
	switch term {
	case let .Parameter(_, type):
		return type
	case let .Return(_, type):
		return type
	case let .Constant(value):
		return typeof(value)
	default:
		return .Boolean
	}
}

public func typeof(value: Value) -> Type {
	switch value {
	case .Boolean:
		return .Boolean
	case .Integer:
		return .Integer
	case .String:
		return .String
	}
}


// MARK: - Imports

import Box
