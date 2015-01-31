//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class EnvironmentTests: XCTestCase {
	func testNodeRepresentingConstantEvaluatesToConstant() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Symbolic(Prelude["true"]!.0) ])
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.constant()), true)
	}

	func testNodeRepresentingFunctionWithNoInputsEvaluatesToFunction() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Symbolic(Prelude["identity"]!.0) ])
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(assertRight(evaluated)?.function()).map { $0(1) }, 1)
	}
}
