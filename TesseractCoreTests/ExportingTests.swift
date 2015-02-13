//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ExportingTests: XCTestCase {
	func testExporting() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: "item1", b: "item2" ], edges: [ Edge((a, 0), (b, 0)) ])
		XCTAssertEqual(exportDOT(graph), "digraph tesseract {\n\t\"item1\" -> \"item2\" [sametail=0,headlabel=0,samehead=0,labeldistance=2,taillabel=0];\n}")
	}
}


// MARK: - Imports

import TesseractCore
import XCTest
