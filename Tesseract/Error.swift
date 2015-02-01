//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Error = (Identifier, String)

internal func error(reason: String, from: Identifier) -> Either<Error, Memo<Value>> {
	return .left((from, reason))
}


// MARK: - Imports

import Either
import Memo
