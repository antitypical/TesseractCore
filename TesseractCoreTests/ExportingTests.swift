//  Copyright (c) 2015 Rob Rix. All rights reserved.

import TesseractCore
import XCTest

final class ExportingTests: XCTestCase {
    func testExporting() {
        let (a, b) = (Identifier(), Identifier())
        let graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
        XCTAssertEqual(export(graph), "digraph tesseract {\n\t\(a) -> \(b);\n}")
    }
}
