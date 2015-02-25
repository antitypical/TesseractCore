//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ImportingTests: XCTestCase {
	func testImporting() {
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
			unaryMinus: "unaryMinus",
			iff: "if",
			lessThan: "lessThan"
			], edges: [
				Edge(x, lessThan.input(0)),
				Edge(zero, lessThan.input(1)),
				Edge(lessThan, iff.input(0)),
				Edge(x, unaryMinus.input(0)),
				Edge(unaryMinus, iff.input(1)),
				Edge(x, iff.input(2)),
				Edge(iff, result.input(0))
			])
		if let (name, parsedGraph) = importDOT(exportDOT("absoluteValue", abs)) {
			let parsedNodes = Set(parsedGraph.nodes.values.array)
			let actualNodes = Set(abs.nodes.values.array)

			XCTAssertEqual(name, "absoluteValue")
			XCTAssertEqual(parsedNodes, actualNodes)
			XCTAssertEqual(parsedGraph.edges.count, abs.edges.count)
		} else {
			XCTFail("could not parse the DOT")
		}
	}
	
	func testMapAcrossImportedGraph() {
		let rawGraph = "digraph test {\n\t\"1\" -> \"2\";\n}"
		if let (_, parsedGraph) = importDOT(rawGraph) {
			let graph = parsedGraph.map { $0.toInt() ?? 0 }
			let (a, b) = (Identifier(), Identifier())
			let expectedGraph = Graph(nodes: [a: 1, b: 2], edges: Set([Edge(a, b.input(0))]))
			let parsedNodes = Set(graph.nodes.values.array)
			let expectedNodes = Set(expectedGraph.nodes.values.array)

			XCTAssertEqual(parsedNodes, expectedNodes)
			XCTAssertEqual(parsedGraph.edges.count, expectedGraph.edges.count)
		} else {
			XCTFail("could not parse the DOT")
		}
	}
}


// MARK: - Imports

import TesseractCore
import XCTest
