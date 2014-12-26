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
		assertEqual(typeof(.Abstraction(.Parameter(0), Box(.Variable(0)))), Type.polymorphic(.function(.Parameter(0), .Parameter(0))))
	}
}
