//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct SetDifferential<T: Hashable>: DifferentialType {
	public init(inserted: Set<T>, deleted: Set<T>) {
		self.inserted = inserted
		self.deleted = deleted
	}

	public let inserted: Set<T>
	public let deleted: Set<T>


	// MARK: DifferentialType

	public static func differentiate(#before: Set<T>, after: Set<T>) -> SetDifferential {
		return SetDifferential(inserted: after.subtract(before), deleted: before.subtract(after))
	}
}
