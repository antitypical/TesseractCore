//  Copyright (c) 2014 Rob Rix. All rights reserved.

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ (), () ], edges: [ Edge((0, 0), (1, 0)) ])
		XCTAssertEqual(graph.nodes.count, 2)
		XCTAssertEqual(graph.edges.count, 1)
	}

	func testSanitizesEdgesOnNodesMutation() {
		var graph = Graph(nodes: [ (), () ], edges: [ Edge((0, 0), (1, 0)) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeAtIndex(0)
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<[()]>(nodes: [])
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.insert(Edge((0, 0), (1, 0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<[Int]> = Graph(nodes: [ 0, 1 ])
	}

	func testAbsoluteValueGraph() {
		XCTAssertEqual(absoluteValue.nodes.count, 6)
		XCTAssertEqual(absoluteValue.edges.count, 7)
	}

	func testMappingAcrossGraph() {
		let graph = Graph(nodes: [ "1", "2" ], edges: [Edge(0, (1, 0))])
		let newGraph = graph.map { $0.toInt() ?? 0 }
		let expectedGraph = Graph(nodes: [ 1, 2 ], edges: [Edge(0, (1, 0))])
		assert(newGraph, ==, expectedGraph)
	}

	func testReductionDoesNotTraverseWithoutEdges() {
		let graph = Graph(nodes: [ "a", "b" ])
		let result = graph.reduce(0, "_") { into, each in into + each }
		XCTAssertEqual(result, "_a")
	}

	func testReductionTraversesEdges() {
		let graph = Graph(nodes: [ "a", "b", "c", "!" ], edges: [ Edge(0, (3, 0)), Edge(1, (3, 1)), Edge(2, (3, 2)) ])
		let reduced = graph.reduce(3, "_") { into, each in into + each }
		XCTAssertEqual(reduced, "_abc!")
	}
}


// MARK: - Imports

import Assertions
import TesseractCore
import XCTest
