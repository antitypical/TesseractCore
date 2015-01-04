//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Prelude
import Tesseract
import XCTest

final class TypeTests: XCTestCase {
	func testConstantTermHasConstantType() {
		XCTAssertEqual(typeof(.Constant(.Integer(0))).either(const(.Boolean), id), Type.Integer)
	}

	func testIdentityTermHasPolymorphicType() {
		assertEqual(typeof(.abstraction(.Parameter(0), .Variable(0))), Type.function(.Parameter(0), .Parameter(0)))
	}

	func testApplicationTermTypechecks() {
		let term = Term.abstraction(.function(.Parameter(0), .Parameter(1)), .abstraction(.Parameter(0), .application(.Variable(0), .Variable(1))))
		// (a -> b) -> a -> b
		let type = typeof(term)
		assertEqual(typeof(term), Type.function(.function(.Parameter(0), .Parameter(1)), .function(.Parameter(0), .Parameter(1))))
	}
}
