//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// O(MN) diffing over forward-indexed collections.
public enum ForwardDifferential<I: SignedIntegerType, T>: Printable {
	case Insert(Box<(I, T, ForwardDifferential)>)
	case Delete(Box<(I, T, ForwardDifferential)>)
	case End

	public func analysis<Result>(@noescape #ifInsert: (I, T, ForwardDifferential) -> Result, @noescape ifDelete: (I, T, ForwardDifferential) -> Result, @autoclosure ifEnd: () -> Result) -> Result {
		switch self {
		case let Insert(values):
			return ifInsert(values.value)
		case let Delete(values):
			return ifDelete(values.value)
		case End:
			return ifEnd()
		}
	}


	public var editDistance: Int {
		return analysis(
			ifInsert: { 1 + $2.editDistance },
			ifDelete: { 1 + $2.editDistance },
			ifEnd: 0)
	}

	public var counts: (Int, Int) {
		return analysis(
			ifInsert: { $2.counts |> { ($0 + 1, $1) } },
			ifDelete: { $2.counts |> { ($0, $1 + 1) } },
			ifEnd: (0, 0))
	}

	public func apply<R: RangeReplaceableCollectionType where R.Generator.Element == T, R.Index.Distance == I>(inout collection: R, delta: I = 0) {
		switch self {
		case let Insert(values):
			collection.insert(values.value.1, atIndex: advance(collection.startIndex, values.value.0 - -delta))
			values.value.2.apply(&collection, delta: delta + 1)
		case let Delete(values):
			collection.removeAtIndex(advance(collection.startIndex, values.value.0 - -delta))
			values.value.2.apply(&collection, delta: delta - 1)
		case End:
			break
		}
	}

	public func apply(delta: I = 0, ifInsert: (I, T) -> (), ifDelete: (I, T) -> ()) {
		switch self {
		case let Insert(values):
			ifInsert(values.value.0 - -delta, values.value.1)
			values.value.2.apply(delta: delta + 1, ifInsert: ifInsert, ifDelete: ifDelete)
		case let Delete(values):
			ifDelete(values.value.0 - -delta, values.value.1)
			values.value.2.apply(delta: delta - 1, ifInsert: ifInsert, ifDelete: ifDelete)
		case End:
			break
		}
	}


	public func map<U>(transform: T -> U) -> ForwardDifferential<I, U> {
		return analysis(
			ifInsert: { ForwardDifferential<I, U>.Insert(Box($0, transform($1), $2.map(transform))) },
			ifDelete: { ForwardDifferential<I, U>.Delete(Box($0, transform($1), $2.map(transform))) },
			ifEnd: ForwardDifferential<I, U>.End)
	}


	private var destructured: DestructuredForwardDifferential<I, T> {
		return analysis(
			ifInsert: { .Insert(Box($0), Box($1), $2) },
			ifDelete: { .Delete(Box($0), Box($1), $2) },
			ifEnd: .End)
	}


	/// Prune nilpotent diffs.
	public func normalize(equals: (T, T) -> Bool) -> ForwardDifferential {
		switch destructured.destructured {
		case let .Insert(i, u, .Delete(j, v, rest)) where i.value == (j.value + 1) && equals(u.value, v.value):
			return rest.normalize(equals)
		case let .Delete(i, u, .Insert(j, v, rest)) where i.value == (j.value - 1) && equals(u.value, v.value):
			return rest.normalize(equals)
		case let .Insert(i, u, rest):
			return Insert(Box(i.value, u.value, rest.restructured.normalize(equals)))
		case let .Delete(i, u, rest):
			return Delete(Box(i.value, u.value, rest.restructured.normalize(equals)))
		case .End:
			return End
		}
	}


	// MARK: Differentiation

	public static func differentiate<C: CollectionType where C.Generator.Element == T, C.Index.Distance == I>(#before: C, after: C, equals: (C.Generator.Element, C.Generator.Element) -> Bool) -> ForwardDifferential {
		return differentiate(before, before.startIndex, 0, after, after.startIndex, 0, equals)
	}

	private static func differentiate<C: CollectionType where C.Generator.Element == T, C.Index.Distance == I>(xs: C, _ xindex: C.Index, _ xoffset: C.Index.Distance, _ ys: C, _ yindex: C.Index, _ yoffset: C.Index.Distance, _ equals: (C.Generator.Element, C.Generator.Element) -> Bool) -> ForwardDifferential {
		func stream(collection: C, index: C.Index, offset: C.Index.Distance) -> (C.Generator.Element, C.Index, C.Index.Distance)? {
			return index != collection.endIndex ?
				(collection[index], index.successor(), offset + 1)
			:	nil
		}

		switch (stream(xs, xindex, xoffset), stream(ys, yindex, yoffset)) {
		case let (.Some(x, xsuccessor, xnext), .Some(y, ysuccessor, ynext)):
			if equals(x, y) {
				return differentiate(xs, xsuccessor, xnext, ys, ysuccessor, ynext, equals)
			} else {
				let insert = ForwardDifferential.Insert(Box(xoffset, y, differentiate(xs, xindex, xoffset, ys, ysuccessor, ynext, equals)))
				let delete = ForwardDifferential.Delete(Box(xoffset, x, differentiate(xs, xsuccessor, xnext, ys, yindex, yoffset, equals)))
				return insert.editDistance < delete.editDistance ? insert : delete
			}
		case let (.Some(x, xsuccessor, xnext), .None):
			return .Delete(Box(xoffset, x, differentiate(xs, xsuccessor, xnext, ys, yindex, yoffset, equals)))
		case let (.None, .Some(y, ysuccessor, ynext)):
			return .Insert(Box(xoffset, y, differentiate(xs, xindex, xoffset, ys, ysuccessor, ynext, equals)))
		case (.None, .None):
			return .End
		}
	}


	// MARK: Printable

	public var description: String {
		return analysis(
			ifInsert: { "+\($0)\($1) \($2)" },
			ifDelete: { "-\($0)\($1) \($2)" },
			ifEnd: "")
	}
}

private enum DestructuredForwardDifferential<I: SignedIntegerType, T> {
	case Insert(Box<I>, Box<T>, ForwardDifferential<I, T>)
	case Delete(Box<I>, Box<T>, ForwardDifferential<I, T>)
	case End

	var destructured: DestructuredForwardDifferential2<I, T> {
		switch self {
		case let Insert(i, v, rest):
			return .Insert(i, v, rest.destructured)
		case let Delete(i, v, rest):
			return .Delete(i, v, rest.destructured)
		case End:
			return .End
		}
	}

	var restructured: ForwardDifferential<I, T> {
		switch self {
		case let Insert(i, v, rest):
			return .Insert(Box(i.value, v.value, rest))
		case let Delete(i, v, rest):
			return .Delete(Box(i.value, v.value, rest))
		case End:
			return .End
		}
	}
}

private enum DestructuredForwardDifferential2<I: SignedIntegerType, T> {
	case Insert(Box<I>, Box<T>, DestructuredForwardDifferential<I, T>)
	case Delete(Box<I>, Box<T>, DestructuredForwardDifferential<I, T>)
	case End
}


// MARK: - Imports

import Box
import Prelude
