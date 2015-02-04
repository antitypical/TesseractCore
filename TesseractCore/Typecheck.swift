//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func typecheck(graph: Graph<Node>, from: Identifier, _ environment: Environment = Prelude, _ context: [Identifier: Type] = [:]) -> Either<Error<Identifier>, Type> {
	return
		context[from].map(Either.right)
	??	graph.nodes[from].map { typecheck(graph, from, $0, environment, context) }
	??	error("could not find identifier in graph", from)
}

private func typecheck(graph: Graph<Node>, from: Identifier, node: Node, environment: Environment, context: [Identifier: Type]) -> Either<Error<Identifier>, Type> {
	switch node {
	case let .Symbolic(symbol):
		return node.inputs(from, graph).reverse().reduce(.right(symbol.type)) { into, each in
			combine(into, typecheck(each), +, uncurry(const))
		}

	case let .Parameter(symbol):
		return .right(symbol.type)

	default:
		return error("unimplmented", from)
	}
}

private func typecheck(symbol: Symbol, pair: (Identifier, Node)?) -> Either<Error<Identifier>, Type> {
	return pair.map { $1.symbol.type == symbol.type ? .right($1.symbol.type) : error("", $0) } ?? .right(symbol.type)
}


// MARK: - Imports

import Either
import Prelude
