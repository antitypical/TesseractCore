//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class ErrorTests: XCTestCase {
	func testLeafErrorsPrintWithIdentifier() {
		let error = Error("a", 0)
		XCTAssertEqual(error.description, "0: a")
	}

	func testBranchErrorsPrintAcrossLines() {
		let error = Error(Error("a", 0), Error(Error("b", 1), Error("c", 2)))
		XCTAssertEqual(error.description, "0: a\n1: b\n2: c")
	}
}
