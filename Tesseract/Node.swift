//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable {
	/// A parameter of a graph.
	case Parameter(Symbol)

	/// A return of a graph.
	case Return(Symbol)

	/// An arbitrary graph node referencing a value bound in the environment.
	case Symbolic(Symbol)


	public var symbol: Symbol {
		switch self {
		case let Parameter(symbol):
			return symbol
		case let Return(symbol):
			return symbol
		case let Symbolic(symbol):
			return symbol
		}
	}
}

public func == (left: Node, right: Node) -> Bool {
	switch (left, right) {
	case let (.Parameter(x), .Parameter(y)):
		return x == y
	case let (.Return(x), .Return(y)):
		return x == y
	case let (.Symbolic(x), .Symbolic(y)):
		return x == y

	default:
		return false
	}
}
