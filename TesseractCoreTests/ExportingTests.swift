//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ExportingTests: XCTestCase {
	func testExporting() {
		let graph = Graph(nodes: [ "item1", "item2" ], edges: [ Edge((0, 0), (1, 0)) ])
		XCTAssertEqual(exportDOT("test", graph), "digraph test {\n\t\"item1\" -> \"item2\" [sametail=0,headlabel=0];\n}")
	}
}


// MARK: - Imports

import TesseractCore
import XCTest
