//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

final class EnvironmentTests: XCTestCase {
	func testNodeReferencingConstantEvaluatesToConstant() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Symbolic(Prelude["true"]!.0) ])
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.constant()), true)
	}
}
