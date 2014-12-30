//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Parameter(0), .Return(0) ], edges: [ Edge(input: SourceIdentifier(base: nil, index: 0), output: DestinationIdentifier(base: nil, index: 0)) ])
	}
}
