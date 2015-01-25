//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
		XCTAssertEqual(graph.nodes.count, 2)
		XCTAssertEqual(graph.edges.count, 1)
	}

	func testSanitizesEdgesOnNodesMutation() {
		let (a, b) = (Identifier(), Identifier())
		var graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeValueForKey(a)
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<()>()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.append(Edge((Identifier(), 0), (Identifier(), 0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<Int> = Graph(nodes: [ Identifier(): 0, Identifier(): 1 ])
	}

	func testAbsoluteValueGraph() {
		let x = Identifier()
		let result = Identifier()
		let zero = Identifier()
		let lessThan = Identifier()
		let iff = Identifier()
		let unaryMinus = Identifier()
		let abs = Graph<String>(nodes: [
			x: "x",
			result: "result",
			zero: "0",
			unaryMinus: "-",
			iff: "if",
			lessThan: "<"
		], edges: [
			Edge(x, lessThan.input(0)),
			Edge(zero, lessThan.input(1)),
			Edge(lessThan, iff.input(0)),
			Edge(x, unaryMinus.input(0)),
			Edge(unaryMinus, iff.input(1)),
			Edge(x, iff.input(2)),
			Edge(iff, result.input(0))
		])
		XCTAssertEqual(abs.nodes.count, 6)
		XCTAssertEqual(abs.edges.count, 7)
	}

	func testReductionDoesNotTraverseWithoutEdges() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: "a", b: "b" ])
		let result = graph.reduce(a, "_") { into, each in into + each.1 }
		XCTAssertEqual(result, "_a")
	}

	func testReductionTraversesEdges() {
		let (a, b, c, result) = (Identifier(), Identifier(), Identifier(), Identifier())
		let graph = Graph(nodes: [ a: "a", b: "b", c: "c", result: "!" ], edges: [ Edge(a, result.input(0)), Edge(b, result.input(0)), Edge(c, result.input(0)) ])
		let reduced = graph.reduce(result, "_") { into, each in into + each.1 }
		XCTAssertEqual(reduced, "_abc!")
	}
}
