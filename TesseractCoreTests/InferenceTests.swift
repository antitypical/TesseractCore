//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	func testGraphsWithoutReturnsHaveUnitType() {
		assert(type(Graph()), ==, .Unit)
	}

	func testGraphsWithOneReturnHaveVariableType() {
		assert(type(Graph(nodes: [Identifier(): .Return((0, .Unit))])), ==, 0)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		assert(type(Graph(nodes: [Identifier(): .Parameter((0, .Unit))])), ==, .function(0, .Unit))
	}

	func testGraphsWithOneParameterAndOneReturnHaveFunctionTypeFromVariableToDifferentVariable() {
		assert(type(Graph(nodes: [Identifier(): .Parameter((0, .Unit)), Identifier(): .Return((0, .Unit))])), ==, .function(1, 0))
	}

	func testGraphsWithMultipleParametersHaveCurriedFunctionType() {
		assert(type(Graph(nodes: [Identifier(): .Parameter((0, .Unit)), Identifier(): .Parameter((1, .Unit))])), ==, .function(1, .function(0, .Unit)))
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
