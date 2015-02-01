//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Error {
	case Node(Identifier, String)
	case Composition([Error])
}

internal func error(reason: String, from: Identifier) -> Either<Error, Memo<Value>> {
	return .left(.Node(from, reason))
}


// MARK: - Imports

import Either
import Memo
