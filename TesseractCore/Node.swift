//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable, Printable {
	/// A parameter of a graph.
	case Parameter(Int, Term)

	/// A return of a graph.
	case Return(Int, Term)

	/// An arbitrary graph node referencing a value bound in the environment.
	case Symbolic(Symbol)

	/// A graph node parameterized by a literal value.
	case Literal(Symbol, Value)


	/// All returns in a given `graph`.
	public static func returns(graph: Graph<Node>) -> [(Identifier, Node)] {
		return Array(
			(lazy(graph.nodes)
				.filter { $1.`return` != nil })
				|>	(flip(sorted) <| { $0.1.index! < $1.1.index! }))
	}

	/// All parameters in a given `graph`.
	public static func parameters(graph: Graph<Node>) -> [(Identifier, Node)] {
		return Array(
			(lazy(graph.nodes)
				.filter { $1.parameter != nil })
				|>	(flip(sorted) <| { $0.1.index! < $1.1.index! }))
	}


	/// Case analysis.
	public func analysis<Result>(@noescape #ifParameter: (Int, Term) -> Result, @noescape ifReturn: (Int, Term) -> Result, @noescape ifSymbolic: Symbol -> Result, @noescape ifLiteral: (Symbol, Value) -> Result) -> Result {
		switch self {
		case let .Parameter(index, type):
			return ifParameter(index, type)
		case let .Return(index, type):
			return ifReturn(index, type)
		case let .Symbolic(symbol):
			return ifSymbolic(symbol)
		case let .Literal(symbol, value):
			return ifLiteral(symbol, value)
		}
	}


	public var type: Term {
		return analysis(
			ifParameter: { $1 },
			ifReturn: { $1 },
			ifSymbolic: { $0.type },
			ifLiteral: { $0.0.type })
	}

	public var symbol: Symbol {
		return analysis(
			ifParameter: { Symbol.index($0.0, type) },
			ifReturn: { Symbol.index($0.0, type) },
			ifSymbolic: id,
			ifLiteral: { $0.0 })
	}

	public var parameter: (Int, Term)? {
		return analysis(
			ifParameter: unit,
			ifReturn: const(nil),
			ifSymbolic: const(nil),
			ifLiteral: const(nil))
	}

	public var `return`: (Int, Term)? {
		return analysis(
			ifParameter: const(nil),
			ifReturn: unit,
			ifSymbolic: const(nil),
			ifLiteral: const(nil))
	}

	/// The index of parameter/return nodes, nil for symbolic nodes.
	public var index: Int? {
		return parameter?.0 ?? `return`?.0
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifParameter: { ".Parameter(\($0))" },
			ifReturn: { ".Return(\($0))" },
			ifSymbolic: { ".Symbolic(\($0))" },
			ifLiteral: { ".Literal(\($0, $1))" })
	}
}


public func == (left: Node, right: Node) -> Bool {
	switch (left, right) {
	case let (.Parameter(x1, x2), .Parameter(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Return(x1, x2), .Return(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Symbolic(x), .Symbolic(y)):
		return x == y
	case let (.Literal(x1, x2), .Literal(y1, y2)):
		return x1 == y1

	default:
		return false
	}
}


// MARK: - Imports

import Prelude
import Manifold
