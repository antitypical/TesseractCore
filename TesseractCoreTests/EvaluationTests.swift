//  Copyright (c) 2015 Rob Rix. All rights reserved.

import TesseractCore
import XCTest

final class EvaluationTests: XCTestCase {
	func createGraph(symbol: Symbol) -> (Identifier, Graph<Node>) {
		let a = Identifier()
		return (a, Graph(nodes: [ a: .Symbolic(symbol) ]))
	}

	func node(symbolName: String) -> Node {
		return .Symbolic(Prelude[symbolName]!.0)
	}

	var constantGraph: (Identifier, Graph<Node>) {
		return createGraph(Prelude["true"]!.0)
	}

	func testConstantNodeEvaluatesToConstant() {
		let (a, graph) = constantGraph
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.value.constant()), true)
	}

	func testFunctionNodeWithNoBoundInputsEvaluatesToFunction() {
		let (a, graph) = createGraph(Prelude["identity"]!.0)
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.value.function() as (Any -> Any)?).map { $0(1) as Int }, 1)
	}

	func testFunctionNodeWithBoundInputAppliesInput() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: node("true"), b: node("identity") ], edges: [ Edge((a, 0), (b, 0)) ])
		let evaluated = evaluate(graph, b)

		assertEqual(assertNotNil(assertRight(evaluated)?.value.constant()), true)
	}

	func testGraphNodeWithNoBoundInputsEvaluatesToGraph() {
		let (a, b) = (Identifier(), Identifier())
		let constant = Graph<Node>(nodes: [ a: node("true"), b: .Return(.Named("return", .Boolean)) ], edges: [ Edge((a, 0), (b, 0)) ])

		let truthy = Symbol.Named("truthy", .Boolean)
		let (c, graph) = createGraph(truthy)
		let evaluated = evaluate(graph, c, [truthy: Value(graph: constant)])
		assertEqual(assertRight(evaluated)?.value.graph.map { $0 == constant } ?? false, true)
	}

	func testGraphNodeWithBoundInputsAppliesInput() {
		let (a, b) = (Identifier(), Identifier())
		let identity = Graph<Node>(nodes: [ a: .Parameter(.Parameter(0, .Parameter(0))), b: .Return(.Named("return", .Parameter(0))) ], edges: [ Edge((a, 0), (b, 0)) ])

		let identitySymbol = Symbol.Named("identity", Type(function: 0, 0))
		let (c, d) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ c: node("true"), d: .Symbolic(identitySymbol) ], edges: [ Edge((c, 0), (d, 0)) ])
		let evaluated = evaluate(graph, d, Prelude + (identitySymbol, Value(graph: identity)))
		println(assertRight(evaluated)?.value)
	}
}
