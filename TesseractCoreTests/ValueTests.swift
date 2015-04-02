//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ValueTests: XCTestCase {
	func testConstantValueDestructuresToSomeOfSameType() {
		assert(Value(1).constant(), ==, 1)
	}

	func testConstantValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(1).constant() as ()?)
	}


	func testFunctionValueDestructuresToSomeOfSameType() {
		assertNotNil(Value(id as Any -> Any).function() as (Any -> Any)?)
	}

	func testFunctionValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(id as Any -> Any).function() as (Int -> Int)?)
	}

	func testConstantValueDestructuresAsFunctionToNone() {
		assertNil(Value(()).function() as (Any -> Any)?)
	}


	func testApplicationOfConstantIsError() {
		let value = Value(())
		assertNotNil(value.apply(value, 0, [:]).left)
	}

	func testApplicationOfIdentityIsArgument() {
		let argument = Value(1)
		let identity = Value(id as Any -> Any)
		assertEqual(assertNotNil(identity.apply(argument, 0, [:]).right)?.value.constant(), 1)
	}
}


// MARK: - Imports

import Assertions
import Prelude
import TesseractCore
import XCTest
