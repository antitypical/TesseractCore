//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct DictionaryDifferential<Key: Hashable, Value: Equatable> {
	public init(inserted: [Key: Value], deleted: [Key: Value]) {
		self.inserted = inserted
		self.deleted = deleted
	}

	public let inserted: [Key: Value]
	public let deleted: [Key: Value]


	// MARK: DifferentialType

	public static func differentiate(#before: Dictionary<Key, Value>, after: Dictionary<Key, Value>) -> DictionaryDifferential {
		let (beforeKeys, afterKeys) = (Set(before.keys), Set(after.keys))
		let changedKeys = Set(lazy(beforeKeys.intersect(afterKeys))
			.filter { before[$0] != after[$0] })

		return DictionaryDifferential(inserted: after[afterKeys.subtract(beforeKeys).union(changedKeys)], deleted: before[beforeKeys.subtract(afterKeys).union(changedKeys)])
	}
}
