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
	public static func returns(graph: Graph<[Node]>) -> [(index: Graph<[Node]>.Index, element: Node)] {
		let returns = filter(enumerate(graph.nodes)) { $1.`return` != nil }
		return sorted(returns) {
			$0.index == $1.index ?
				$0.element.index! < $1.element.index!
			:	$0.index < $1.index
		}
	}

	/// All parameters in a given `graph`.
	public static func parameters(graph: Graph<[Node]>) -> [(index: Graph<[Node]>.Index, element: Node)] {
		let parameters = filter(enumerate(graph.nodes)) { $1.parameter != nil }
		return sorted(parameters) {
			$0.index == $1.index ?
				$0.element.index! < $1.element.index!
			:	$0.index < $1.index
		}
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

	public func analysis<Result>(ifParameter: ((Int, Term) -> Result)? = nil, ifReturn: ((Int, Term) -> Result)? = nil, ifSymbolic: (Symbol -> Result)? = nil, ifLiteral: ((Symbol, Value) -> Result)? = nil, otherwise: () -> Result) -> Result {
		switch self {
		case let .Parameter(index, type):
			return ifParameter?(index, type) ?? otherwise()
		case let .Return(index, type):
			return ifReturn?(index, type) ?? otherwise()
		case let .Symbolic(symbol):
			return ifSymbolic?(symbol) ?? otherwise()
		case let .Literal(symbol, value):
			return ifLiteral?(symbol, value) ?? otherwise()
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

	public var literal: Value? {
		return analysis(
			ifLiteral: { $1 },
			otherwise: const(nil))
	}

	public var parameter: (Int, Term)? {
		return analysis(
			ifParameter: unit,
			otherwise: const(nil))
	}

	public var `return`: (Int, Term)? {
		return analysis(
			ifReturn: unit,
			otherwise: const(nil))
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


// MARK: - Imports

import Prelude
import Manifold
