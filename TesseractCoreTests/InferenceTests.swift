//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionType() {
		let generated = constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit))], edges: []))
		assert(simplify(generated.0), == ,.function(0, .Unit))
	}
}


private func simplify(type: Term) -> Term {
	return Substitution(lazy(enumerate(type.freeVariables)).map { ($1, Term(integerLiteral: $0)) }).apply(type)
}


import Assertions
import Manifold
import TesseractCore
import XCTest
