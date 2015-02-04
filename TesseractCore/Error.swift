//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Error<Identifier>: Printable {
	public init(_ reason: String, _ from: Identifier) {
		self = Leaf(Box(from), reason)
	}

	public init(_ error1: Error, _ error2: Error) {
		self = Branch(Box(error1), Box(error2))
	}


	case Leaf(Box<Identifier>, String)
	case Branch(Box<Error>, Box<Error>)


	// MARK: Printable

	public var description: String {
		switch self {
		case let Leaf(identifier, reason):
			return "\(identifier): \(reason)"

		case let Branch(x, y):
			return "\(x)\n\(y)"
		}
	}
}

public func + <Identifier> (left: Error<Identifier>, right: Error<Identifier>) -> Error<Identifier> {
	return Error(left, right)
}

internal func error(reason: String, from: Identifier) -> Either<Error<Identifier>, Memo<Value>> {
	return .left(Error(reason, from))
}

internal func error(reason: String, from: Identifier) -> Either<Error<Identifier>, Type> {
	return .left(Error(reason, from))
}

internal func coalesce<S, T, U>(eithers: [(S, Either<Error<U>, T>)]) -> Either<Error<U>, [(S, T)]> {
	return reduce(eithers, .right([])) { into, each in
		into.either(
			{ error in each.1.left.map { .left(Error(error, $0)) } ?? into },
			{ value in each.1.map { value + [ (each.0, $0) ] } }
		)
	}
}


// MARK: - Imports

import Box
import Either
import Memo
