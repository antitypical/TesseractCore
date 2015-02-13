//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ImportingTests: XCTestCase {
	func testImporting() {
		let x = Identifier()
		let result = Identifier()
		let zero = Identifier()
		let lessThan = Identifier()
		let iff = Identifier()
		let unaryMinus = Identifier()
		let abs = Graph<String>(name: "abs", nodes: [
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
		let parsedGraph = importDOT(exportDOT(abs))
		let parsedNodes = Set(parsedGraph.nodes.values.array)
		let actualNodes = Set(abs.nodes.values.array)
		
		XCTAssertEqual(parsedGraph.name, abs.name)
		XCTAssertEqual(parsedNodes, actualNodes)
		XCTAssertEqual(parsedGraph.edges.count, abs.edges.count)
	}

	func testEdgeParsing() {
		let (source, destination) = parseEdge("\t\"item1\" -> \"item2\";")!
		XCTAssertEqual(source, "item1")
		XCTAssertEqual(destination, "item2")
	}
}


// MARK: - Imports

import TesseractCore
import XCTest
