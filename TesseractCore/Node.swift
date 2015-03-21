//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable, Printable {
	/// A parameter of a graph.
	case Parameter(Symbol)

	/// A return of a graph.
	case Return(Symbol)

	/// An arbitrary graph node referencing a value bound in the environment.
	case Symbolic(Symbol)


	public var isReturn: Bool {
		switch self {
		case Return:
			return true
		default:
			return false
		}
	}


	// MARK: Printable

	public var description: String {
		switch self {
		case let Parameter(symbol):
			return ".Parameter(\(symbol))"
		case let Return(symbol):
			return ".Return(\(symbol))"
		case let Symbolic(symbol):
			return ".Symbolic(\(symbol))"
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
