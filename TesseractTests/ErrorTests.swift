//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class ErrorTests: XCTestCase {
	func testLeafErrorsPrintWithIdentifier() {
		let error = Error("a", 0)
		XCTAssertEqual(error.description, "0: a")
	}
}
