//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class TypeDifferentialTests: XCTestCase {
	// MARK: Diffing

	func testTheDiffOfATypeWithItselfIsIdempotent() {
		assert(TypeDifferentiator.differentiate(before: .Bool, after: .Bool), ==, .Bool)
	}

	func testTheDiffOfAConstructorWithADifferentConstructorReplacesIt() {
		assert(TypeDifferentiator.differentiate(before: .Unit, after: .Bool), ==, .Patch(.Unit, .Bool))
	}

	func testTheDiffOfAVariableWithAConstructorReplacesIt() {
		assert(TypeDifferentiator.differentiate(before: 0, after: .Unit), ==, TypeDifferential.Patch(.variable(0), .Unit))
	}

	func testComputesLocalPatches() {
		assert(TypeDifferentiator.differentiate(before: .function(.Unit, .Unit), after: .function(.Unit, .Bool)), ==, .function(.Unit, .Patch(.Unit, .Bool)))
	}
}


import Assertions
import Manifold
import TesseractCore
import XCTest
