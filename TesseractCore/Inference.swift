//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, assumptions: AssumptionSet, constraints: ConstraintSet) {
	let returns = Node.returns(graph)
	if returns.count == 0 {
		return (.Unit, [:], [])
	}
	return (Term(), [:], [])
}


import Manifold
