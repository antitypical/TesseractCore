//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// O(MN) diffing over forward-indexed collections.
public enum ForwardDifferential<I: SignedIntegerType, T> {
	case Insert(Box<(I, T, ForwardDifferential)>)
	case Delete(Box<(I, T, ForwardDifferential)>)
	case End


	public var count: Int {
		switch self {
		case let Insert(values):
			return 1 + values.value.2.count
		case let Delete(values):
			return 1 + values.value.2.count
		case End:
			return 0
		}
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


	public func map<U>(transform: T -> U) -> ForwardDifferential<I, U> {
		switch self {
		case let Insert(values):
			return .Insert(Box(values.value.0, transform(values.value.1), values.value.2.map(transform)))
		case let Delete(values):
			return .Delete(Box(values.value.0, transform(values.value.1), values.value.2.map(transform)))
		case let End:
			return .End
		}
	}


	// MARK: DifferentialType

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
				return insert.count < delete.count ? insert : delete
			}
		case let (.Some(x, xsuccessor, xnext), .None):
			return .Delete(Box(xoffset, x, differentiate(xs, xsuccessor, xnext, ys, yindex, yoffset, equals)))
		case let (.None, .Some(y, ysuccessor, ynext)):
			return .Insert(Box(xoffset, y, differentiate(xs, xindex, xoffset, ys, ysuccessor, ynext, equals)))
		case (.None, .None):
			return .End
		}
	}
}


// MARK: - Imports

import Box
