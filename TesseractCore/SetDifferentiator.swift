//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct SetDifferentiator<T: Hashable> {
	public static func differentiate(#before: Set<T>, after: Set<T>) -> UnorderedDifferential<T> {
		return UnorderedDifferential(inserted: after.subtract(before), deleted: before.subtract(after))
	}
}
