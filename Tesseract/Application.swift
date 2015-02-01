//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func apply(value: Value, identifier: Identifier, symbol: Symbol, parameters: [(Edge.Destination, Memo<Value>)]) -> Either<Error<Identifier>, Memo<Value>> {
	return .right(Memo(value))
}


// MARK: - Imports

import Either
import Memo
