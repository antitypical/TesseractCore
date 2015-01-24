//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Parameter(0): (), .Return(0): () ], edges: [ Edge(.Parameter(0), .Return(0)) ])
	}

	func testSanitizesEdgesOnNodesMutation() {
		var graph = Graph(nodes: [ .Parameter(0): (), .Return(0): () ], edges: [ Edge(.Parameter(0), .Return(0)) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeValueForKey(.Parameter(0))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<()>()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.append(Edge(.Parameter(0), .Return(0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<Int> = Graph(nodes: [ .Parameter(0): 0, .Return(0): 1 ])
	}

	func testAbsoluteValueGraph() {
		let x = SourceIdentifier.Parameter(0)
		let result = DestinationIdentifier.Return(0)
		let zero = NodeIdentifier()
		let lessThan = NodeIdentifier()
		let iff = NodeIdentifier()
		let unaryMinus = NodeIdentifier()
		let abs = Graph<String>(nodes: [
			x.identifier: "x",
			result.identifier: "result",
			zero.identifier: "0",
			unaryMinus.identifier: "-",
			iff.identifier: "if",
			lessThan.identifier: "<"
		], edges: [
			Edge(x, lessThan.parameter(0)),
			Edge(zero.result(0), lessThan.parameter(1)),
			Edge(lessThan.result(0), iff.parameter(0)),
			Edge(x, unaryMinus.parameter(0)),
			Edge(unaryMinus.result(0), iff.parameter(1)),
			Edge(x, iff.parameter(2)),
			Edge(iff.result(0), result)
		])
	}
}
