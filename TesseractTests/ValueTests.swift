//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

final class ValueTests: XCTestCase {
	func testConstantValueDestructuresWithFunctionOfSameType() {
		assertEqual(Value(constant: 1).constant(), 1)
	}

	func testConstantValueDestructuresToNilWithFunctionOfDifferentType() {
		assertNil(Value(constant: 1).constant() as ()?)
	}
}
