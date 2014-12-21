//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Type: Equatable {
	case Boolean
	case Integer
	case String

	case Function(Box<Type>, Box<Type>)

	case Generic(Int, Box<Type>)
	case Parameter(Int)

	case Sum([Type])
	case Product([Type])
}


public func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case (.Boolean, .Boolean), (.Integer, .Integer), (.String, .String):
		return true

	case let (.Function(x1, y1), .Function(x2, y2)):
		return x1 == x2 && y1 == y2

	case let (.Generic(n1, x1), .Generic(n2, x2)):
		return n1 == n2 && x1 == x2
	// fixme: this is insufficient, we need to know the context
	case let (.Parameter(x), .Parameter(y)):
		return x == y

	case let (.Sum(xs), .Sum(ys)):
		return xs == ys
	case let (.Product(xs), .Product(ys)):
		return xs == ys

	default:
		return false
	}
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
