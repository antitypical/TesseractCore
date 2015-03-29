//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class TypeDifferentialTests: XCTestCase {
	// MARK: Diffing

	func testTheDiffOfATypeWithItselfIsEmpty() {
		assert(TypeDifferentiator.differentiate(before: .Bool, after: .Bool), ==, TypeDifferential.Empty)
	}

	func testTheDiffOfAConstructorWithADifferentConstructorReplacesIt() {
		assert(TypeDifferentiator.differentiate(before: .Unit, after: .Bool), ==, TypeDifferential.Bool)
	}

	func testTheDiffOfNestedFunctionsIsPartial() {
		assert(TypeDifferentiator.differentiate(before: .function(.Unit, .function(.Unit, .Unit)), after: .function(.Unit, .function(.Unit, .Bool))), ==, TypeDifferential.function(.Empty, .function(.Empty, .Bool)))
	}

	func testTheDiffOfAVariableWithAConstructorReplacesIt() {
		assert(TypeDifferentiator.differentiate(before: 0, after: .Unit), ==, TypeDifferential.Unit)
	}
}


import Assertions
import Manifold
import TesseractCore
import XCTest
