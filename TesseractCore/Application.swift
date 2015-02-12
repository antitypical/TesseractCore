//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func apply(value: Value, identifier: Identifier, symbol: Symbol, parameters: [(Int, Memo<Value>)], environment: Environment) -> Either<Error<Identifier>, Memo<Value>> {
	return
		reduce(parameters, (-1, nil as Either<Error<Identifier>, Memo<Value>>?)) { into, each in
			(each.0, into.1 ?? (each.0 != into.0 ? nil : error("expected 0 or 1 edges to input \(each.0), but multiple were found \(each.0)", identifier)))
		}.1
	??	(parameters.last.map { $0.0 < symbol.type.arity ? nil : error("too many input edges (\($0.0 - 1))", identifier) } ?? nil)
	??	reduce(parameters, .right(Memo(evaluated: value))) { into, each in into.right?.value.apply(each.1.value, identifier, environment) ?? into }
}


// MARK: - Imports

import Either
import Memo
