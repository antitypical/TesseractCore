//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Error {
	public init(_ reason: String, _ from: Identifier) {
		self = Leaf(from, reason)
	}

	public init(_ error1: Error, _ error2: Error) {
		self = Branch(Box(error1), Box(error2))
	}


	case Leaf(Identifier, String)
	case Branch(Box<Error>, Box<Error>)
}

internal func error(reason: String, from: Identifier) -> Either<Error, Memo<Value>> {
	return .left(Error(reason, from))
}


// MARK: - Imports

import Box
import Either
import Memo
