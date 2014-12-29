//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Identifier: Hashable {
	private let value: String

	public var hashValue: Int {
		return value.hashValue
	}
}

public func == (left: Identifier, right: Identifier) -> Bool {
	return left.value == right.value
}

public struct Node {
	let title: String
	let inputs: [(String, Identifier?)] = []
	let outputs: [(String, Identifier?)] = []
}

public struct Graph {
	let title: String
	let nodes: [Identifier: Node]
}
