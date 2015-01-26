//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Graph<T> {
	public init(nodes: [Identifier: T] = [:], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
		sanitize(edges)
	}


	// MARK: Primitive methods

	public var nodes: [Identifier: T] {
		willSet {
			let removed = Set(nodes.keys) - Set(newValue.keys)
			if removed.count == 0 { return }
			edges = edges.filter {
				!removed.contains($0.source.identifier) && !removed.contains($0.destination.identifier)
			}
		}
	}

	public var edges: Set<Edge> {
		didSet {
			sanitize(edges - oldValue)
		}
	}

	
	// MARK: Higher-order methods

	public func filter(includeNode: (Identifier, T) -> Bool) -> Graph {
		return Graph(nodes: nodes.filter(includeNode), edges: edges)
	}

	public func filter(includeEdge: Edge -> Bool) -> Graph {
		return Graph(nodes: nodes, edges: edges.filter(includeEdge))
	}

	public func filter(includeNode: (Identifier, T) -> Bool = const(true), includeEdge: Edge -> Bool = const(true)) -> Graph {
		return Graph(nodes: nodes.filter(includeNode), edges: edges.filter(includeEdge))
	}


	public func reduce<Result>(from: Identifier, _ initial: Result, _ combine: (Result, (Identifier, T)) -> Result) -> Result {
		return reduce(from, [], initial, combine)
	}

	public func reduce<Result>(from: Identifier, var _ visited: Set<Identifier>, _ initial: Result, _ combine: (Result, (Identifier, T)) -> Result) -> Result {
		if visited.contains(from) { return initial }
		visited.append(from)

		if let node = nodes[from] {
			let inputs = edges
				|> (flip(Swift.filter) <| { $0.destination.identifier == from })
				|> (flip(sorted) <| { $0.source < $1.source })
				|> (flip(Swift.map) <| { $0.source.identifier })
			return combine(inputs.reduce(initial) { into, each in
				self.reduce(each.0, visited, into, combine)
			}, (from, node))
		}
		return initial
	}


	// MARK: Private

	private mutating func sanitize(added: Set<Edge>) {
		if added.count == 0 { return }
		let keys = nodes.keys
		edges -= added.filter {
			!contains(keys, $0.source.identifier) && !contains(keys, $0.destination.identifier)
		}
	}
}


// MARK: - Imports

import Prelude
import Set
