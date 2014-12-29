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


public struct Edge {
	let input: Identifier
	let output: Identifier
}

public struct Graph {
	let title: String
	let parameters: [Identifier]
	let returns: [Identifier]

	let nodes: [Identifier]
	let edges: [Edge]
}
