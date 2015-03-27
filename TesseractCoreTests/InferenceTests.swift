//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	// MARK: Types

	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}

	func testGraphsWithOneReturnArePolymorphic() {
		assert(constraints(Graph(nodes: [Identifier(): .Return(0, 0)])).0, ==, 0)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, 0)])).0, ==, Term.function(0, .Unit))
	}

	func testGraphsWithOneParameterAndOneReturnHavePolymorphicFunctionType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, 0), Identifier(): .Return(0, 1)])).0, ==, Term.function(0, 1))
	}

	func testGraphsWithMultipleParametersHaveCurriedFunctionType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, 0), Identifier(): .Parameter(1, 1)])).0, ==, Term.function(0, .function(1, .Unit)))
	}

	func testGraphsWithMultipleReturnsHaveProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Return(0, 0), Identifier(): .Return(1, 1)])).0, ==, Term.product(0, 1))
	}

	func testGraphsWithSeveralReturnsEtc() {
		assert(constraints(Graph(nodes: [Identifier(): .Return(0, 0), Identifier(): .Return(1, 1), Identifier(): .Return(2, 2)])).0, ==, Term.product(0, .product(1, 2)))
	}

	func testGraphsWithMultipleParametersAndMultipleReturnsHaveCurriedFunctionTypeProducingProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, 0), Identifier(): .Parameter(1, 1), Identifier(): .Return(0, 2), Identifier(): .Return(1, 3)])).0, ==, Term.function(0, .function(1, .product(2, 3))))
	}

	func testIdentityGraphTypeInitiallyHasTwoTypeVariables() {
		assert(constraints(identity).0.freeVariables, ==, [0, 1])
	}


	// MARK: Constraints

	func testIdentityGraphHasConstraintsRelatingItsTypeVariables() {
		assert(constraints(identity).1, ==, [ 0 === 1 ])
	}


	// MARK: Types

	func testIdentityIsGeneralized() {
		assert(typeOf(identity).left, ==, nil)
		assert(typeOf(identity).right, ==, Term.function(0, 0).generalize())
	}
}


// MARK: Fixtures

private let identity: Graph<Node> = {
	let (a, b) = (Identifier(), Identifier())
	return Graph(nodes: [ a: .Parameter(0, 0), b: .Return(0, 1) ], edges: [ Edge((a, 0), (b, 0)) ])
}()


import Assertions
import Manifold
import Prelude
import TesseractCore
import XCTest
