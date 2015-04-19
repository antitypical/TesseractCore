//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// An unordered differential.
///
/// This does not conform to DifferentialType because it does not do any diffing itself; rather, it can be used as an intermediate diff between other representations, or otherwise constructed manually.
public struct UnorderedDifferential<T> {
	public init() {
		self.init(inserted: [], deleted: [])
	}

	public init<S1: SequenceType, S2: SequenceType where S1.Generator.Element == T, S2.Generator.Element == T>(inserted: S1, deleted: S2) {
		self.inserted = Array(inserted)
		self.deleted = Array(deleted)
	}

	public let inserted: [T]
	public let deleted: [T]


	// MARK: Higher-order functions

	public func map<U>(transform: T -> U) -> UnorderedDifferential<U> {
		return UnorderedDifferential<U>(inserted: lazy(inserted).map(transform), deleted: lazy(deleted).map(transform))
	}

	public func mapAll<S: SequenceType>(transform: [T] -> S) -> UnorderedDifferential<S.Generator.Element> {
		return UnorderedDifferential<S.Generator.Element>(inserted: transform(inserted), deleted: transform(deleted))
	}

	public func flatMap<S: SequenceType>(transform: T -> S) -> UnorderedDifferential<S.Generator.Element> {
		return UnorderedDifferential<S.Generator.Element>(inserted: lazy(inserted).flatMap(transform), deleted: lazy(deleted).flatMap(transform))
	}

	public func filter(predicate: T -> Bool) -> UnorderedDifferential<T> {
		return UnorderedDifferential(inserted: lazy(inserted).filter(predicate), deleted: lazy(deleted).filter(predicate))
	}

	public func partition(predicate: T -> Bool) -> (UnorderedDifferential<T>, UnorderedDifferential<T>) {
		let i = partition(inserted, predicate)
		let d = partition(deleted, predicate)
		return (UnorderedDifferential(inserted: i.0, deleted: d.0), UnorderedDifferential(inserted: i.1, deleted: d.1))
	}

	private func partition<S: SequenceType>(sequence: S, _ predicate: S.Generator.Element -> Bool) -> ([S.Generator.Element], [S.Generator.Element]) {
		return reduce(sequence, ([], [])) {
			predicate($1) ?
				($0.0 + [$1], $0.1)
			:	($0.0, $0.1 + [$1])
		}
	}
}


/// Returns the union of two unordered differentials. Makes no effort to normalize.
public func + <T> (left: UnorderedDifferential<T>, right: UnorderedDifferential<T>) -> UnorderedDifferential<T> {
	return UnorderedDifferential(inserted: left.inserted + right.inserted, deleted: left.deleted + right.deleted)
}


import Prelude
