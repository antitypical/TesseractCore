//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class EnvironmentTests: XCTestCase {
	func testConstantNodeEvaluatesToConstant() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Symbolic(Prelude["true"]!.0) ])
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.constant()), true)
	}

	func testFunctionNodeWithNoBoundInputsEvaluatesToFunction() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Symbolic(Prelude["identity"]!.0) ])
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.function() as (Any -> Any)?).map { $0(1) as Int }, 1)
	}
}
