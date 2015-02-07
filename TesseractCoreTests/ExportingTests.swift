//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ExportingTests: XCTestCase {
    func testExporting() {
        let (a, b) = (Identifier(), Identifier())
        let graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
        XCTAssertEqual(exportDOT(graph), "digraph tesseract {\n\t\"\(a)\" -> \"\(b)\";\n}")
    }
}


// MARK: - Imports

import TesseractCore
import XCTest
