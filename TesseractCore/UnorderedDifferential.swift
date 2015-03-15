//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// An unordered differential.
///
/// This does not conform to DifferentialType because it does not do any diffing itself; rather, it can be used as an intermediate diff between other representations, or otherwise constructed manually.
public struct UnorderedDifferential<T> {
	public init<S1: SequenceType, S2: SequenceType where S1.Generator.Element == T, S2.Generator.Element == T>(inserted: S1, deleted: S2) {
		self.inserted = Array(inserted)
		self.deleted = Array(deleted)
	}

	public let inserted: [T]
	public let deleted: [T]
}