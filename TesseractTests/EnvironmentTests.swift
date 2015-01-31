//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

/// Apparently this is necessary to match functions.
func const<T>(x: T) -> (Any -> Any) -> T {
	return { _ in x }
}

final class EnvironmentTests: XCTestCase {
	func testNodeReferencingConstantEvaluatesToConstant() {
		let a = Identifier()
		let graph = Graph(nodes: [ a: Node.Abstraction(Prelude["unit"]!.0) ])
		let evaluated = evaluate(graph, a)
		let e = evaluated.right
//		let f = { evaluated.right }
//		println(e)
//		println(f())
		if let value = assertNotNil(evaluated.right) {
			if let value: () = value.destructure(id, const(())) {

			} else {
				failure("ugh")
			}
		} else {
			failure("ugh \(evaluated.left)")
		}
	}
}
