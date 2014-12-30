//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class IdentifierTests: XCTestCase {
	func testNodeStringValueIsUUIDString() {
		let identifier = Identifier()
		XCTAssertEqual(countElements(identifier.description), 36)
	}
}
