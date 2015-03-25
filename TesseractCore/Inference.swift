//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func typeOf(graph: Graph<Node>) -> Either<Error<Identifier>, Term> {
	let (type, constraints) = TesseractCore.constraints(graph)
	return solve(constraints).either(
		ifLeft: { Either.left(Error($0.description, Identifier())) },
		ifRight: { Either.right($0.apply(type).generalize()) })
}


public func constraints(graph: Graph<Node>) -> (Term, constraints: ConstraintSet) {
	let parameters = Node.parameters(graph).map { typeOf(graph, $0.0)! }.reverse()
	let returns = Node.returns(graph).map { typeOf(graph, $0.0)! }.reverse()

	let constraints = ConstraintSet(lazy(graph.edges).flatMap { [ typeOf(graph, $0.source.identifier)!.`return` === typeOf(graph, $0.destination)! ] })

	let returnType: Term = first(returns).map { reduce(dropFirst(returns), $0, flip(Term.product)) } ?? .Unit
	return (reduce(parameters, returnType, flip(Term.function)), constraints)
}


private func typeOf(graph: Graph<Node>, identifier: Identifier) -> Term? {
	return graph.nodes[identifier]?.type
}

/// Returns the type of the node input at `endpoint` in `graph`. For `return` nodes (which have no parameters), this will be the node’s type.
private func typeOf(graph: Graph<Node>, endpoint: (identifier: Identifier, inputIndex: Int)) -> Term? {
	return graph.nodes[endpoint.identifier].map {
		$0.`return` != nil ?
			$0.type
		:	$0.type.parameters[endpoint.inputIndex]
	}
}


import Either
import Manifold
import Prelude
