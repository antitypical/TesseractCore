//  Copyright (c) 2015 Rob Rix. All rights reserved.

import TesseractCore
import XCTest

final class NodeTests: XCTestCase {
	func node(symbolName: String) -> Node {
		return .Symbolic(Prelude[symbolName]!.0)
	}

	func testConstantSymbolsHaveNoInputs() {
		let a = Identifier()
		let n = node("unit")
		let graph = Graph(nodes: [ a: n ])
		assertEqual(n.inputs(a, graph).count, 0)
	}
}
