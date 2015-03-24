//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, constraints: ConstraintSet) {
	let parameters = Node.parameters(graph)
	let returns = Node.returns(graph)
	let returnType: Term = reduce(returns, nil) { $0.0.map { .product(Term(), $0) } ?? Term() } ?? .Unit
	return (simplify(reduce(parameters, returnType) {
		.function(Term(), $0.0)
	}), [])
}


private func typeOf(graph: Graph<Node>, identifier: Identifier) -> Term? {
	return graph.nodes[identifier]?.type
}


private func simplify(type: Term) -> Term {
	return Substitution(
		(type.freeVariables
			|>	sorted
			|>	reverse
			|>	enumerate
			|>	lazy)
			.map {
				($1, Term(integerLiteral: $0))
			})
		.apply(type)
		.generalize()
}


import Manifold
import Prelude
