//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Parameter(0): (), .Return(0): () ], edges: [ Edge(.Parameter(0), .Return(0)) ])
	}

	func testSanitizesEdgesOnNodesMutation() {
		let a = SourceIdentifier.Parameter(0)
		let b = DestinationIdentifier.Return(0)
		var graph = Graph(nodes: [ .Source(a): (), .Destination(b): () ], edges: [ Edge(a, b) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeValueForKey(.Source(a))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<()>()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.append(Edge(.Parameter(0), .Return(0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<Int> = Graph(nodes: [.Parameter(0): 0, .Return(0): 1])
	}
}
