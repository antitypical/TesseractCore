//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public typealias Source = (identifier: Identifier, outputIndex: Int)
	public typealias Destination = (identifier: Identifier, inputIndex: Int)

	public init(_ source: Source, _ destination: Destination) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: Identifier, _ destination: Destination) {
		self.init(source.output(0), destination)
	}

	public let source: Source
	public let destination: Destination


	// MARK: Hashable

	public var hashValue: Int {
		return (source.identifier.hashValue + source.outputIndex) ^ (destination.identifier.hashValue + destination.inputIndex)
	}
}

public func == (left: Edge.Source, right: Edge.Source) -> Bool {
	return left.identifier == right.identifier && left.outputIndex == right.outputIndex
}

public func == (left: Edge.Destination, right: Edge.Destination) -> Bool {
	return left.identifier == right.identifier && left.inputIndex == right.inputIndex
}

public func < (left: Edge.Source, right: Edge.Source) -> Bool {
	return left.identifier == right.identifier ?
		left.outputIndex < right.outputIndex
	:	left.identifier < right.identifier
}

public func < (left: Edge.Destination, right: Edge.Destination) -> Bool {
	return left.identifier == right.identifier ?
		left.inputIndex < right.inputIndex
	:	left.identifier < right.identifier
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
}


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

import Set
import Prelude
