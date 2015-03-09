//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol DifferentialType {
	typealias Differentiable

	static func differentiate(#before: Differentiable, after: Differentiable) -> Self
}


// MARK: - Set

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


// MARK: - Dictionary

public struct DictionaryDifferential<Key: Hashable, Value>: DifferentialType {
	public init(inserted: [Key: Value], deleted: Set<Key>) {
		self.inserted = inserted
		self.deleted = deleted
	}

	public let inserted: [Key: Value]
	public let deleted: Set<Key>


	// MARK: DifferentialType

	public static func differentiate(#before: Dictionary<Key, Value>, after: Dictionary<Key, Value>) -> DictionaryDifferential {
		let (beforeKeys, afterKeys) = (Set(before.keys), Set(after.keys))

		return DictionaryDifferential(inserted: after[afterKeys.subtract(beforeKeys)], deleted: beforeKeys.subtract(afterKeys))
	}
}


// MARK: - Graph

public struct GraphDifferential<T>: DifferentialType {
	public let nodes: DictionaryDifferential<Identifier, T>
	public let edges: SetDifferential<Edge>

	// MARK: DifferentialType

	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> GraphDifferential {
		return GraphDifferential(nodes: .differentiate(before: before.nodes, after: after.nodes), edges: .differentiate(before: before.edges, after: after.edges))
	}
}


// MARK: - Implementation details

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
