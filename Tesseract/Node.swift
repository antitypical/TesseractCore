//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable {
	/// A parameter of a graph.
	case Parameter(String)

	/// A return of a graph.
	case Return(String)

	/// An arbitrary graph node abstracting a symbol.
	case Abstraction(Symbol)
}

public func == (left: Node, right: Node) -> Bool {
	switch (left, right) {
	case let (.Parameter(x), .Parameter(y)):
		return x == y
	case let (.Return(x), .Return(y)):
		return x == y
	case let (.Abstraction(x), .Abstraction(y)):
		return x == y

	default:
		return false
	}
}
