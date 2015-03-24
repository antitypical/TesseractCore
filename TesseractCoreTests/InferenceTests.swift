//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	// MARK: Types

	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}

	func testGraphsWithOneReturnHaveVariableType() {
		assert(constraints(Graph(nodes: [Identifier(): .Return((0, .Unit))])).0, ==, 0)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit))])).0, ==, .function(0, .Unit))
	}

	func testGraphsWithOneParameterAndOneReturnHaveFunctionTypeFromVariableToDifferentVariable() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit)), Identifier(): .Return((0, .Unit))])).0, ==, .function(0, 1))
	}

	func testGraphsWithMultipleParametersHaveCurriedFunctionType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit)), Identifier(): .Parameter((1, .Unit))])).0, ==, .function(0, .function(1, .Unit)))
	}

	func testGraphsWithMultipleReturnsHaveProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Return((0, .Unit)), Identifier(): .Return((1, .Unit))])).0, ==, .product(0, 1))
	}

	func testGraphsWithMultipleParametersAndMultipleReturnsHaveCurriedFunctionTypeProducingProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter((0, .Unit)), Identifier(): .Parameter((1, .Unit)), Identifier(): .Return((0, .Unit)), Identifier(): .Return((1, .Unit))])).0, ==, .function(0, .function(1, .product(2, 3))))
	}
}


// MARK: Fixtures

private let identity: Graph<Node> = {
	let (a, b) = (Identifier(), Identifier())
	return Graph(nodes: [ a: .Parameter((0, .Unit)), b: .Return((0, .Unit)) ], edges: [ Edge((a, 0), (b, 0)) ])
}()


import Assertions
import Manifold
import Prelude
import TesseractCore
import XCTest
