//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, constraints: ConstraintSet) {
	let parameters = Node.parameters(graph).map { typeOf(graph, $0.0)! }.reverse()
	let returns = Node.returns(graph).map { typeOf(graph, $0.0)! }.reverse()

	let constraints = ConstraintSet(lazy(graph.edges).flatMap { [ typeOf(graph, $0.source.identifier)!.`return` === typeOf(graph, $0.destination)! ] })

	let returnType: Term? = reduce(returns, nil) { previous, each in previous.map { Term.product(each, $0) } ?? each }
	return (simplify(reduce(parameters, returnType ?? .Unit, flip(Term.function))), constraints)
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
