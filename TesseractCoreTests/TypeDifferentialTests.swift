//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class TypeDifferentialTests: XCTestCase {

	// MARK: Patching

	func testEmptyDiffIsIdempotent() {
		assert(TypeDifferential.Empty.apply(Term.Bool), ==, Term.Bool)
	}
}


import Assertions
import Manifold
import TesseractCore
import XCTest
