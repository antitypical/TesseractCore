//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class TypeDifferentialTests: XCTestCase {

	// MARK: Patching

	func testEmptyDiffIsIdempotent() {
		assert(TypeDifferential.Empty.apply(Term.Bool), ==, Term.Bool)
	}

	func testUnitDiffReplacesOtherConstructors() {
		assert(TypeDifferential.Patch(Type.constructed(.Unit)).apply(Term.Bool), ==, Term.Unit)
	}

	func testUnitDiffDoesNotReplaceVariables() {
		assert(TypeDifferential.Patch(Type.constructed(.Unit)).apply(0), ==, 0)
	}
}


import Assertions
import Manifold
import TesseractCore
import XCTest