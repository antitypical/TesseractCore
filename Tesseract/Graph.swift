//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge {
	public init(input: Identifier, output: Identifier) {
		self.input = input
		self.output = output
	}

	public let input: Identifier
	public let output: Identifier
}

public struct Graph {
	public init(title: String, nodes: [Identifier] = [], edges: [Edge] = []) {
		self.title = title
		self.nodes = nodes
		self.edges = edges
	}

	public let title: String

	public let nodes: [Identifier]
	public let edges: [Edge]
}
