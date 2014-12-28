//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box
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
}
