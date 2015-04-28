//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	// MARK: Types

	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph<[Node]>(nodes: [])).0, ==, .Unit)
	}

	func testGraphsWithOneReturnArePolymorphic() {
		assert(constraints(Graph(nodes: [.Return(0, 0)])).0, ==, 0)
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		assert(constraints(Graph(nodes: [.Parameter(0, 0)])).0, ==, Term.function(0, .Unit))
	}

	func testGraphsWithOneParameterAndOneReturnHavePolymorphicFunctionType() {
		assert(constraints(Graph(nodes: [.Parameter(0, 0), .Return(0, 1)])).0, ==, Term.function(0, 1))
	}

	func testGraphsWithMultipleParametersHaveCurriedFunctionType() {
		assert(constraints(Graph(nodes: [.Parameter(0, 0), .Parameter(1, 1)])).0, ==, Term.function(0, .function(1, .Unit)))
	}

	func testGraphsWithMultipleReturnsHaveProductType() {
		assert(constraints(Graph(nodes: [.Return(0, 0), .Return(1, 1)])).0, ==, Term.product(0, 1))
	}

	func testGraphsWithSeveralReturnsEtc() {
		assert(constraints(Graph(nodes: [.Return(0, 0), .Return(1, 1), .Return(2, 2)])).0, ==, Term.product(0, .product(1, 2)))
	}

	func testGraphsWithMultipleParametersAndMultipleReturnsHaveCurriedFunctionTypeProducingProductType() {
		assert(constraints(Graph(nodes: [.Parameter(0, 0), .Parameter(1, 1), .Return(0, 2), .Return(1, 3)])).0, ==, Term.function(0, .function(1, .product(2, 3))))
	}

	func testIdentityGraphTypeInitiallyHasTwoTypeVariables() {
		assert(constraints(identity).0.freeVariables, ==, [0, 1])
	}

	func testConstantGraphTypeInitiallyHasThreeTypeVariables() {
		assert(constraints(constant).0.freeVariables, ==, [0, 1, 2])
	}


	// MARK: Constraints

	func testIdentityGraphHasConstraintsRelatingItsTypeVariables() {
		assert(constraints(identity).1, ==, [ 0 === 1 ])
	}

	func testConstantGraphHasConstraintRelatingFirstParameterTypeToReturnType() {
		assert(constraints(constant).1, ==, [ 0 === 2 ])
	}

	func testWrappingANodeIntroducesConstraintsAgainstInstantiatedTypes() {
		let result = constraints(constantByWrappingNode).1
		assert(result, ==, [ 0 === -1, 1 === -2, 2 === -1 ])
	}


	// MARK: Types

	func testIdentityIsGeneralized() {
		assert(typeOf(identity).left, ==, nil)
		assert(typeOf(identity).right, ==, Term.function(0, 0).generalize())
	}

	func testConstantIsGeneralized() {
		assert(typeOf(constant).left, ==, nil)
		assert(typeOf(constant).right, ==, Term.function(0, .function(1, 0)).generalize())
	}

	func testInstantiatesNodeTypes() {
		assert(typeOf(constantByWrappingNode).left, ==, nil)
		assert(typeOf(constantByWrappingNode).right, ==, Term.function(0, .function(1, 0)).generalize())
	}
}


// MARK: Fixtures

private let identity: Graph<[Node]> = {
	Graph(nodes: [ .Parameter(0, 0), .Return(0, 1) ], edges: [ Edge(Source(nodeIndex: 0, outputIndex: 0), Destination(nodeIndex: 1, inputIndex: 0)) ])
}()

private let constant: Graph<[Node]> = {
	Graph(nodes: [ .Parameter(0, 0), .Parameter(1, 1), .Return(0, 2) ], edges: [ Edge(Source(nodeIndex: 0, outputIndex: 0), Destination(nodeIndex: 2, inputIndex: 0)) ])
}()

private let constantPermutation: Graph<[Node]> = {
	Graph(nodes: [ .Parameter(0, 0), .Return(0, 1), .Parameter(1, 2), ], edges: [ Edge(Source(nodeIndex: 0, outputIndex: 0), Destination(nodeIndex: 1, inputIndex: 0)) ])
}()

private let constantByWrappingNode: Graph<[Node]> = {
	let constantType = Term.forall([0, 1], .function(0, .function(1, 0)))
	return Graph(nodes: [ .Parameter(0, 0), .Parameter(1, 1), .Return(0, 2), .Symbolic(Symbol.named("constant", constantType)) ], edges: [ Edge(Source(nodeIndex: 0, outputIndex: 0), Destination(nodeIndex: 3, inputIndex: 0)), Edge(Source(nodeIndex: 1, outputIndex: 0), Destination(nodeIndex: 3, inputIndex: 1)), Edge(Source(nodeIndex: 3, outputIndex: 0), Destination(nodeIndex: 2, inputIndex: 0)) ])
}()


import Assertions
import Manifold
import Prelude
import TesseractCore
import XCTest
