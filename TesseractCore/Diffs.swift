//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol DifferentialType {
	typealias Differentiable

	static func differentiate(#before: Differentiable, after: Differentiable) -> Self
}

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

extension Dictionary {
	subscript (keys: Set<Key>) -> Dictionary {
		var result: Dictionary = [:]
		for key in keys {
			if let value = self[key] {
				result.updateValue(value, forKey: key)
			}
		}
		return result
	}
}
