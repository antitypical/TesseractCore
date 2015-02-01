//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func apply(value: Value, symbol: Symbol, parameters: [(Edge.Destination, Memo<Either<Error, Value>>)]) -> Either<Error, Value> {
	return .right(value)
}


// MARK: - Imports

import Either
import Memo
