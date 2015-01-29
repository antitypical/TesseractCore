//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Environment: DictionaryLiteralConvertible {
	private let bindings: [Symbol: Value]

	public subscript (key: String) -> (Symbol, Value)? {
		let index = find(bindings) { symbol, _ in symbol.name == key }
		return index.map { self.bindings[$0] }?
	}


	// MARK: DictionaryLiteralConvertible

	public init(dictionaryLiteral elements: (Symbol, Value)...) {
		bindings = Dictionary(elements)
	}
}

public let Prelude: Environment = [
	Symbol(name: "identity", parameters: [ .Parameter(0) ], returns: [ .Parameter(0) ]): .Function(id),
	Symbol(name: "const", parameters: [ .Parameter(0) ], returns: [ Type(function: .Parameter(1), .Parameter(0)) ]): .Function(const as Any -> Any -> Any),
	Symbol(name: "unit", parameters: [], returns: [ .Unit ]): .Constant(()),
]


public typealias Error = (Identifier, String)

public func evaluate(graph: Graph<Node>, from: Identifier, environment: Environment = Prelude) -> Either<Error, Value> {
	return evaluate(graph, from, environment, [:])
}

private func evaluate(graph: Graph<Node>, from: Identifier, environment: Environment, var visited: [Identifier: Value]) -> Either<Error, Value> {
	func error(reason: String) -> Either<Error, Value> {
		return .left((from, reason))
	}

	if let node = graph.nodes[from] {
		let inputs = lazy(graph.edges)
			.filter { $0.destination.identifier == from }
			.map { ($0.destination, graph.nodes[$0.source.identifier]!) }
			|> (flip(sorted) <| { $0.0 < $1.0 })

		switch node {
		case let .Abstraction(symbol):
			break

		case .Parameter:
			break

		case .Return where inputs.count != 1:
			return error("expected one return edge, but \(inputs.count) were found")

		case .Return:
			return evaluate(graph, inputs[0].0.identifier, environment, visited)
		}
	} else {
		return error("node does not exist in graph")
	}
	return error("unimplemented")
}


// MARK: - Imports

import Either
import Prelude
