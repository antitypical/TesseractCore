//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func evaluate(graph: Graph<[Node]>, from: Graph<[Node]>.Index, environment: Environment) -> Either<Error<Int>, Memo<Value>> {
	return count(graph.nodes) > from ?
		evaluate(graph, from, environment, graph.nodes[from])
	:	error("could not find identifier in graph", from)
}

private func evaluate(graph: Graph<[Node]>, from: Graph<[Node]>.Index, environment: Environment, node: Node) -> Either<Error<Int>, Memo<Value>> {
	let recur: Source<[Node]> -> Either<Error<Graph<[Node]>.Index>, Memo<Value>> = { source in
		evaluate(graph, source.nodeIndex, environment, graph.nodes[source.nodeIndex])
	}
	let inputs = lazy(graph.edges)
		.filter { $0.destination.nodeIndex == from }
		.map { ($0.destination.inputIndex, recur($0.source)) }
		|> (flip(sorted) <| { $0.0 < $1.0 })

	switch node {
	case let .Symbolic(symbol):
		return coalesce(inputs) >>- { inputs in
				environment[symbol].map { apply($0, from, symbol, inputs, environment) }
			??	error("\(symbol) not found in environment", from)
		}

	case let .Literal(symbol, value):
		return .right(Memo(evaluated: value))

	case let .Parameter(symbol):
		return environment[.Index(0, .Unit)]
			.map { .right(Memo(evaluated: $0)) }
		??	error("did not find parameter in environment", from)

	case .Return where inputs.count != 1:
		return error("expected one return edge, but \(inputs.count) were found", from)

	case .Return:
		return inputs[0].1
	}
}


// MARK: - Imports

import Either
import Memo
import Prelude
