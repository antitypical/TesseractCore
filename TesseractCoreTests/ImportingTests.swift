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
        let parsedGraph = importGraphViz(export(abs))!
        XCTAssertEqual(parsedGraph.edges.count, abs.edges.count)
        XCTAssertEqual(parsedGraph.nodes.count, abs.nodes.count)
    }
    
    func testEdgeParsing() {
        let (source, destination) = parseEdge("\t\"item1\" -> \"item2\";\n")!
        XCTAssertEqual(source, "item1")
        XCTAssertEqual(destination, "item2")
    }
}


// MARK: - Imports

import TesseractCore
import XCTest
