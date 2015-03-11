//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct SetDifferential<T: Hashable>: DifferentialType {
	public init<S1: SequenceType, S2: SequenceType where S1.Generator.Element == T, S2.Generator.Element == T>(inserted: S1, deleted: S2) {
		self.inserted = Set(inserted)
		self.deleted = Set(deleted)
	}

	public let inserted: Set<T>
	public let deleted: Set<T>


	// MARK: DifferentialType

	public static func differentiate(#before: Set<T>, after: Set<T>) -> SetDifferential {
		return SetDifferential(inserted: after.subtract(before), deleted: before.subtract(after))
	}
}
