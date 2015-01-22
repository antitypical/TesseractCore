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
}
