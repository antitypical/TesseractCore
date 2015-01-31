//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func apply(value: Value, parameters: [(Edge.Destination, Node)]) -> Either<Error, Value> {
	return .right(value)
}


// MARK: - Imports

import Either
