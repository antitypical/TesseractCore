//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class TermTests: XCTestCase {
	func testIdentityTermEvaluatesToItsOperand() {
		let identity = Term.abstraction(.Parameter(0), .Variable(0))
		let operand = Term.Constant(.Boolean(true))
		let application = Term.application(identity, operand)
		assertEqual(eval(application), operand)
	}
}
