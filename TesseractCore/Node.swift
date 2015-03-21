//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable, Printable {
	/// A parameter of a graph.
	case Parameter(Symbol)

	/// A return of a graph.
	case Return(Symbol)

	/// An arbitrary graph node referencing a value bound in the environment.
	case Symbolic(Symbol)


	/// Case analysis.
	public func analysis<Result>(@noescape #ifParameter: Symbol -> Result, @noescape ifReturn: Symbol -> Result, @noescape ifSymbolic: Symbol -> Result) -> Result {
		switch self {
		case let Parameter(symbol):
			return ifParameter(symbol)
		case let Return(symbol):
			return ifReturn(symbol)
		case let Symbolic(symbol):
			return ifSymbolic(symbol)
		}
	}


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
		return analysis(
			ifParameter: { ".Parameter(\($0))" },
			ifReturn: { ".Return(\($0))" },
			ifSymbolic: { ".Symbolic(\($0))" })
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
