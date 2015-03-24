//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}
}


import Assertions
import Manifold
import TesseractCore
import XCTest
