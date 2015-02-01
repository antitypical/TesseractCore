//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Error: Printable {
	public init(_ reason: String, _ from: Identifier) {
		self = Leaf(from, reason)
	}

	public init(_ error1: Error, _ error2: Error) {
		self = Branch(Box(error1), Box(error2))
	}


	case Leaf(Identifier, String)
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

internal func error(reason: String, from: Identifier) -> Either<Error, Memo<Value>> {
	return .left(Error(reason, from))
}

internal func coalesce<S, T>(eithers: [(S, Either<Error, T>)]) -> Either<Error, [(S, T)]> {
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
