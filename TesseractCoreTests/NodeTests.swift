//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class NodeTests: XCTestCase {
	func testEmptyGraphsHaveNoReturns() {
		assert(Node.returns(Graph(nodes: [])), ==, [])
	}

	func testFindsReturnsInWellFormedGraphs() {
		let node = Node.Return(0, 0)
		let graph = Graph(nodes: [ node ], edges: [])
		assert(Node.returns(graph).first?.element, ==, node)
	}

	func testEmptyGraphsHaveNoParameters() {
		assert(Node.parameters(Graph(nodes: [])), ==, [])
	}

	func testFindsParametersInWellFormedGraphs() {
		let node = Node.Parameter(0, 0)
		let graph = Graph(nodes: [ node ])
		assert(Node.parameters(graph).first?.element, ==, node)
	}
}


import Assertions
import TesseractCore
import XCTest
