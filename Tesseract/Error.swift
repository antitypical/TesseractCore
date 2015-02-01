//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Error {
	case Leaf(Identifier, String)
	case Branch(Box<Error>, Box<Error>)
}

internal func error(reason: String, from: Identifier) -> Either<Error, Memo<Value>> {
	return .left(.Leaf(from, reason))
}


// MARK: - Imports

import Box
import Either
import Memo
