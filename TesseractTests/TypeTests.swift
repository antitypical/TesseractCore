//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class TypeTests: XCTestCase {
	func testConstantTypesHaveArityZero() {
		XCTAssertEqual(Type.Unit.arity, 0)
	}

	func testUnaryFunctionTypesHaveArityOne() {
		XCTAssertEqual((.Unit --> .Unit).arity, 1)
	}

	func testBinaryFunctionTypesHaveArityTwo() {
		XCTAssertEqual((.Unit --> .Unit --> .Unit).arity, 2)
	}
}
