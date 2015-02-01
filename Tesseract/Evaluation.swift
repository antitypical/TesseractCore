//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func evaluate(graph: Graph<Node>, from: Identifier, _ environment: Environment = Prelude, _ visited: [Identifier: Value] = [:]) -> Either<Error, Value> {
	return
		visited[from].map(Either.right)
	??	graph.nodes[from].map { evaluate(graph, from, environment, visited, $0) }
	??	error("could not find identifier in graph", from)
}

private func evaluate(graph: Graph<Node>, from: Identifier, environment: Environment, visited: [Identifier: Value], node: Node) -> Either<Error, Value> {
	let recur: Edge.Source -> Memo<Either<Error, Value>> = { source in
		Memo(evaluate(graph, source.identifier, environment, visited, graph.nodes[source.identifier]!))
	}
	let inputs = lazy(graph.edges)
		.filter { $0.destination.identifier == from }
		.map { ($0.destination, recur($0.source)) }
		|> (flip(sorted) <| { $0.0 < $1.0 })

	switch node {
	case let .Symbolic(symbol):
		return
			environment[symbol].map(flip(apply) <| inputs <| symbol)
		??	error("\(symbol) not found in environment", from)

	case .Parameter:
		break

	case .Return where inputs.count != 1:
		return error("expected one return edge, but \(inputs.count) were found", from)

	case .Return:
		return evaluate(graph, inputs[0].0.identifier, environment, visited)
	}
	return error("don’t know how to evaluate \(node)", from)
}


// MARK: - Imports

import Either
import Memo
import Prelude
