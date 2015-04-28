//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func typeOf(graph: Graph<[Node]>) -> Either<Error<Graph<[Node]>.Index>, Term> {
	let (type, constraints, _) = TesseractCore.constraints(graph)
	return solve(constraints)
		.either(
		ifLeft: { Either.left(Error($0.description, count(graph.nodes))) },
		ifRight: {
			let t = $0.apply(type)
			let n = normalization(t)
			return Either.right(n.apply(t).generalize())
		})
}

public func typeOf(graph: Graph<[Node]>) -> (Either<Error<Graph<[Node]>.Index>, Term>, Graph<[Term]>) {
	let (type, constraints, types) = TesseractCore.constraints(graph)
	return solve(constraints)
		.map { normalization(type).compose($0) }
		.either(
			ifLeft: { (Either.left(Error($0.description, count(graph.nodes))), types) },
			ifRight: { s in
				let t = s.apply(type)
				let n = normalization(t)
				let applied = Graph(nodes: types.nodes.map { n.apply(s.apply($0)) }, edges: types.edges)
				return (Either.right(n.apply(t).generalize()), applied)
			})
}


public func constraints(graph: Graph<[Node]>) -> (Term, constraints: ConstraintSet, graph: Graph<[Term]>) {
	var cursor = 0
	let instantiated = graph.map { $0.type.instantiate { Variable(integerLiteral: --cursor) } }

	let parameters = Node.parameters(graph).map { instantiated.nodes[$0.0] }.reverse()
	let returns = Node.returns(graph).map { instantiated.nodes[$0.0] }.reverse()

	let constraints = ConstraintSet(lazy(graph.edges).flatMap { (edge: Edge) -> [Constraint] in
		let source = instantiated.nodes[edge.source.nodeIndex].returns[edge.source.outputIndex]
		let node = instantiated.nodes[edge.destination.nodeIndex]
		let destination = node.parameters.isEmpty ? node : node.parameters[edge.destination.inputIndex]
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
			ifKind: const([], []),
			ifUnit: const([], []),
			ifFunction: binary,
			ifSum: binary,
			ifProduct: binary,
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
