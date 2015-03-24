//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func constraints(graph: Graph<Node>) -> (Term, constraints: ConstraintSet) {
	let types = graph.map { $0.symbol.type }

	let returns = Node.returns(graph).map { typeOf(graph, $0.0)! }
	let parameters = Node.parameters(graph).map { typeOf(graph, $0.0)! }
	let returnType: Term? = reduce(returns, nil) { previous, each in previous.map { Term.product(each, $0) } ?? each }
	return (simplify(reduce(parameters, returnType ?? .Unit, flip(Term.function))), [])
}


private func typeOf(graph: Graph<Node>, identifier: Identifier) -> Term? {
	return graph.nodes[identifier]?.type
}

private func typeOf(graph: Graph<Node>, endpoint: (identifier: Identifier, inputIndex: Int)) -> Term? {
	return graph.nodes[endpoint.identifier]?.symbol.type.parameters[endpoint.inputIndex]
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
