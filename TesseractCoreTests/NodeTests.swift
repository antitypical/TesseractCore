//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class NodeTests: XCTestCase {
	func testEmptyGraphsHaveNoReturns() {
		assert(Node.returns(Graph()), ==, [])
	}

	func testFindsReturnsInWellFormedGraphs() {
		let node = Node.Return((0, .Unit))
		let graph = Graph(nodes: [Identifier(): node], edges: [])
		assert(Node.returns(graph).first?.1, ==, node)
	}
}


import Assertions
import TesseractCore
import XCTest
