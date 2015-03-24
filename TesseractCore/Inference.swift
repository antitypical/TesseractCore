//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, assumptions: AssumptionSet, constraints: ConstraintSet) {
	let parameters = Node.parameters(graph)
	let returns = Node.returns(graph)
	let returnType: Term = reduce(returns, nil) { $0.0.map { .product(Term(), $0) } ?? Term() } ?? .Unit
	return (reduce(parameters, returnType) {
		.function(Term(), $0.0)
	}, [:], [])
}


import Manifold
