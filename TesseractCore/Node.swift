//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable, Printable {
	/// A parameter of a graph.
	case Parameter(Symbol.IndexType)

	/// A return of a graph.
	case Return(Symbol.IndexType)

	/// An arbitrary graph node referencing a value bound in the environment.
	case Symbolic(Symbol)


	/// Case analysis.
	public func analysis<Result>(@noescape #ifParameter: (Int, Term) -> Result, @noescape ifReturn: (Int, Term) -> Result, @noescape ifSymbolic: Symbol -> Result) -> Result {
		switch self {
		case let Parameter(index, type):
			return ifParameter(index, type)
		case let Return(symbol):
			return ifReturn(symbol)
		case let Symbolic(symbol):
			return ifSymbolic(symbol)
		}
	}


	public var symbol: Symbol {
		return analysis(
			ifParameter: Symbol.index,
			ifReturn: Symbol.index,
			ifSymbolic: id)
	}

	public var parameter: Symbol.IndexType? {
		return analysis(
			ifParameter: unit,
			ifReturn: const(nil),
			ifSymbolic: const(nil))
	}

	public var `return`: Symbol.IndexType? {
		return analysis(
			ifParameter: const(nil),
			ifReturn: unit,
			ifSymbolic: const(nil))
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


// MARK: - Imports

import Prelude
import Manifold
