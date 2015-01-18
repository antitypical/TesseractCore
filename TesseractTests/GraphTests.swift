//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Parameter(0), .Return(0) ], edges: [ Edge(SourceIdentifier(base: nil, index: 0), DestinationIdentifier(base: nil, index: 0)) ])
	}

	func testSanitizesEdgesOnNodesMutation() {
		let a = SourceIdentifier(base: nil, index: 0)
		let b = DestinationIdentifier(base: nil, index: 0)
		var graph = Graph(nodes: [ .Source(a), .Destination(b) ], edges: [ Edge(a, b) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.remove(.Source(a))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.append(Edge(SourceIdentifier(base: nil, index: 0), DestinationIdentifier(base: nil, index: 0)))
		XCTAssertEqual(graph.edges.count, 0)
	}
}
