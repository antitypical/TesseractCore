//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Prelude
import Tesseract
import XCTest

final class ValueTests: XCTestCase {
	func testConstantValueDestructuresToSomeOfSameType() {
		assertEqual(Value(constant: 1).constant(), 1)
	}

	func testConstantValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(constant: 1).constant() as ()?)
	}

	func testFunctionValueDestructuresAsConstantToNone() {
		assertNil(Value(function: id as Any -> Any).constant() as Any?)
	}


	func testFunctionValueDestructuresToSomeOfSameType() {
		assertNotNil(Value(function: id as Any -> Any).function() as (Any -> Any)?)
	}

	func testFunctionValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(function: id as Any -> Any).function() as (Int -> Int)?)
	}

	func testConstantValueDestructuresAsFunctionToNone() {
		assertNil(Value(constant: ()).function() as (Any -> Any)?)
	}


	func testApplicationOfConstantIsNil() {
		let value = Value(constant: ())
		assertNil(value.apply(value))
	}

	func testApplicationOfIdentityIsArgument() {
		let argument = Value(constant: 1)
		let identity = Value(function: id as Any -> Any)
		assertEqual(assertNotNil(identity.apply(argument))?.constant(), 1)
	}
}
