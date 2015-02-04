//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func typecheck(graph: Graph<Node>, from: Identifier, _ environment: Environment = Prelude, _ context: [Identifier: Type] = [:]) -> Either<Error<Identifier>, Type> {
	return
		context[from].map(Either.right)
	??	graph.nodes[from].map { typecheck(graph, from, $0, environment, context) }
	??	error("could not find identifier in graph", from)
}

private func typecheck(graph: Graph<Node>, from: Identifier, node: Node, environment: Environment, context: [Identifier: Type]) -> Either<Error<Identifier>, Type> {
	switch node {
	case let .Parameter(symbol):
		return .right(symbol.type)
	default:
		return error("unimplmented", from)
	}
}


// MARK: - Imports

import Either
