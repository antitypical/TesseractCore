//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Node: Equatable, Printable {
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


	public var isReturn: Bool {
		switch self {
		case Return:
			return true
		default:
			return false
		}
	}


	public func inputs(identifier: Identifier, _ graph: Graph<Node>) -> [(Symbol, (Identifier, Node)?)] {
		let inputNodes = Dictionary(lazy(graph.edges)
			.filter { $0.destination.identifier == identifier }
			.map { ($0.destination.inputIndex, ($0.source.identifier, graph.nodes[$0.source.identifier]!)) })
		return Array(lazy(enumerate(symbol.type.parameters))
			.map { (Symbol($0, $1), inputNodes[$0]) })
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
