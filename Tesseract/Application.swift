//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func apply(value: Value, identifier: Identifier, symbol: Symbol, parameters: [(Int, Memo<Value>)]) -> Either<Error<Identifier>, Memo<Value>> {
	return
		reduce(parameters, (-1, nil as Either<Error<Identifier>, Memo<Value>>?)) { into, each in
			(each.0, into.1 ?? (each.0 != into.0 ? nil : error("expected 0 or 1 edges to input \(each.0), but multiple were found \(each.0)", identifier)))
		}.1
	??	.right(Memo(value))
}


// MARK: - Imports

import Either
import Memo
