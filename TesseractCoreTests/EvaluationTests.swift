//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class EvaluationTests: XCTestCase {
	func createGraph(symbol: Symbol) -> (Identifier, Graph<Node>) {
		return (Identifier(0), Graph(nodes: [ .Symbolic(symbol) ]))
	}

	func node(symbolName: String) -> Node {
		return .Symbolic(Prelude[symbolName]!.0)
	}

	var constantGraph: (Identifier, Graph<Node>) {
		return createGraph(Prelude["true"]!.0)
	}

	func testConstantNodeEvaluatesToConstant() {
		let (a, graph) = constantGraph
		let evaluated = evaluate(graph, a, Prelude)

		assertEqual(assertNotNil(evaluated.right?.value.constant()), true)
	}

	func testFunctionNodeWithNoBoundInputsEvaluatesToFunction() {
		let (a, graph) = createGraph(Prelude["identity"]!.0)
		let evaluated = evaluate(graph, a, Prelude)

		assertEqual(assertNotNil(evaluated.right?.value.function() as (Any -> Any)?).map { $0(1) as! Int }, 1)
	}

	func testFunctionNodeWithBoundInputAppliesInput() {
		let graph = Graph(nodes: [ node("true"), node("identity") ], edges: [ Edge((0, 0), (1, 0)) ])
		let evaluated = evaluate(graph, 1, Prelude)

		assertEqual(assertNotNil(evaluated.right?.value.constant()), true)
	}

	func testGraphNodeWithNoBoundInputsEvaluatesToGraph() {
		let constant = Graph<Node>(nodes: [ node("true"), .Return(0, 0) ], edges: [ Edge((0, 0), (1, 0)) ])

		let truthy = Symbol.Named("truthy", .Bool)
		let (c, graph) = createGraph(truthy)
		let evaluated = evaluate(graph, c, [truthy: Value(constant)])
		let right = evaluated.right?.value.graph.map { $0 == constant }
		assertEqual(right ?? false, true)
	}

	func testGraphNodeWithBoundInputsAppliesInput() {
		let identity = Graph<Node>(nodes: [ .Parameter(0, 0), .Return(0, 0) ], edges: [ Edge((0, 0), (1, 0)) ])

		let identitySymbol = Symbol.Named("identity", .forall([ 0 ], .function(0, 0)))
		let graph = Graph(nodes: [ node("true"), .Symbolic(identitySymbol) ], edges: [ Edge((0, 0), (1, 0)) ])
		let evaluated = evaluate(graph, 1, Prelude + (identitySymbol, Value(identity)))
		assert(evaluated.right?.value.constant(), ==, true)
	}
}


// MARK: - Imports

import Assertions
import Manifold
import TesseractCore
import XCTest
