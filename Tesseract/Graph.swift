//  Copyright (c) 2014 Rob Rix. All rights reserved.

typealias Identifier = String

public struct Node {
	let title: String
	let inputs: [(String, Identifier?)] = []
	let outputs: [(String, Identifier?)] = []
}

public struct Graph {
	let title: String
	let nodes: [Identifier: Node]
}
