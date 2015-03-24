//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class NodeTests: XCTestCase {
	func testEmptyGraphsHaveNoReturns() {
		assert(Node.returns(Graph()), ==, [])
	}
}


import Assertions
import TesseractCore
import XCTest
