//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

final class ValueTests: XCTestCase {
	func testConstantValueDestructuresToSomeOfSameType() {
		assertEqual(Value(constant: 1).constant(), 1)
	}

	func testConstantValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(constant: 1).constant() as ()?)
	}

	func testFunctionValueDestructuresAsConstantToNone() {
		assertNil(Value(function: id as Any -> Any).constant() as Any?)
	}
}
