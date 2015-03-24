//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, assumptions: AssumptionSet, constraints: ConstraintSet) {
	let parameters = Node.parameters(graph)
	let returns = Node.returns(graph)
	return (reduce(parameters, returns.count > 0 ? Term() : Term.Unit) {
		.function(Term(), $0.0)
	}, [:], [])
}


import Manifold
