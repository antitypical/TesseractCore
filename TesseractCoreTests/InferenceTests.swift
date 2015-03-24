//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		let generated = constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit))], edges: []))
		assert(simplify(generated.0), == ,.function(0, .Unit))
	}
}


private func type(graph: Graph<Node>) -> Term {
	return simplify(constraints(graph).0)
}

private func simplify(type: Term) -> Term {
	return Substitution(lazy(enumerate(type.freeVariables |> (flip(sorted) <| { $0.value < $1.value }))).map { ($1, Term(integerLiteral: $0)) }).apply(type)
}


import Assertions
import Manifold
import Prelude
import TesseractCore
import XCTest
