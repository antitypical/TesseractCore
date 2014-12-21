//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

final class TypeTests: XCTestCase {
	func testConstantTermHasConstantType() {
		XCTAssertEqual(typeof(.Constant(.Integer(0))).either(const(.Boolean), id), Type.Integer)
	}
}
