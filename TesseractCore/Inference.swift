//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func typeOf(graph: Graph<Node>) -> Either<Error<Identifier>, Term> {
	let (type, constraints, _) = TesseractCore.constraints(graph)
	return solve(constraints)
		.either(
		ifLeft: { Either.left(Error($0.description, Identifier())) },
		ifRight: {
			let t = $0.apply(type)
			let n = normalization(t)
			return Either.right(n.apply(t).generalize())
		})
}


public func constraints(graph: Graph<Node>) -> (Term, constraints: ConstraintSet, graph: Graph<Term>) {
	var cursor = 0
	let instantiated = graph.map { $0.type.instantiate { Variable(integerLiteral: --cursor) } }

	let parameters = Node.parameters(graph).map { instantiated.nodes[$0.0]! }.reverse()
	let returns = Node.returns(graph).map { instantiated.nodes[$0.0]! }.reverse()

	let constraints = ConstraintSet(lazy(graph.edges).flatMap { (edge: Edge) -> [Constraint] in
		let source = instantiated.nodes[edge.source.identifier]!.returns[edge.source.outputIndex]
		let destination = instantiated.nodes[edge.destination.identifier].map { $0.parameters.isEmpty ? $0 : $0.parameters[edge.destination.inputIndex] }!
		return [ source === destination ]
	})

	let returnType: Term = first(returns).map { reduce(dropFirst(returns), $0, flip(Term.product)) } ?? .Unit
	return (reduce(parameters, returnType, flip(Term.function)), constraints, instantiated)
}


/// Substitute the variables in a type such that it is represented densely with variables in-order starting at 0.
private func normalization(type: Term) -> Substitution {
	/// Produce the free variables of `type` in depth first order.
	func freeVariables(type: Type<(Set<Variable>, [Variable])>) -> (Set<Variable>, [Variable]) {
		let binary: ((Set<Variable>, [Variable]), (Set<Variable>, [Variable])) -> (Set<Variable>, [Variable]) = { t1, t2 in
			(t1.0.union(t2.0), t1.1 + t2.1.filter { !t1.0.contains($0) })
		}
		return type.analysis(
			ifVariable: { ([$0], [$0]) },
			ifConstructed: {
				$0.analysis(
					ifUnit: ([], []),
					ifFunction: binary,
					ifSum: binary,
					ifProduct: binary)
			},
			ifUniversal: { $1 })
	}
	return Substitution(
		(cata(freeVariables)(type).1
			|>	enumerate
			|>	lazy)
			.map {
				($1, Term(integerLiteral: $0))
			})
}


import Either
import Manifold
import Prelude
