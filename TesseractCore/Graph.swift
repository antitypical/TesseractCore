//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Graph<T>: CollectionType, Printable {
	public init(nodes: [Identifier: T] = [:], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
		sanitize(edges)
	}


	// MARK: Primitive methods

	public subscript (identifier: Identifier) -> NodeView<T>? {
		return nodes[identifier].map { NodeView(graph: self, identifier: identifier, value: $0) }
	}

	public var nodes: Dictionary<Identifier, T> {
		willSet {
			let removed = Set(nodes.keys).subtract(Set(newValue.keys))
			if removed.count == 0 { return }
			edges = Set(lazy(edges).filter {
				!removed.contains($0.source.identifier) && !removed.contains($0.destination.identifier)
			})
		}
	}

	public var edges: Set<Edge> {
		didSet {
			sanitize(edges.subtract(oldValue))
		}
	}


	// MARK: Higher-order methods

	public func map<U>(mapping: T -> U) -> Graph<U> {
		return Graph<U>(nodes: nodes.map { ($0, mapping($1)) }, edges: edges)
	}

	public func filter(includeNode: (Identifier, T) -> Bool = const(true), includeEdge: Edge -> Bool = const(true)) -> Graph {
		return Graph(nodes: nodes.filter(includeNode), edges: Set(lazy(edges).filter(includeEdge)))
	}


	public func reduce<Result>(from: Identifier, _ initial: Result, _ combine: (Result, (Identifier, T)) -> Result) -> Result {
		return reduce(from, [], initial, combine)
	}

	public func reduce<Result>(from: Identifier, var _ visited: Set<Identifier>, _ initial: Result, _ combine: (Result, (Identifier, T)) -> Result) -> Result {
		if visited.contains(from) { return initial }
		visited.insert(from)

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


	public func find(predicate: (Identifier, T) -> Bool) -> DictionaryIndex<Identifier, T>? {
		for index in nodes.startIndex..<nodes.endIndex {
			if predicate <| nodes[index] { return index }
		}
		return nil
	}


	// MARK: CollectionType

	public typealias Index = Dictionary<Identifier, T>.Index

	public var startIndex: Index {
		return nodes.startIndex
	}

	public var endIndex: Index {
		return nodes.endIndex
	}

	public subscript(index: Index) -> NodeView<T> {
		let (identifier, value) = nodes[index]
		return NodeView(graph: self, identifier: identifier, value: value)
	}


	// MARK: Printable

	public var description: String {
		let nodesDescription = join(",\n", lazy(nodes).map {
			"\t\t\($0)"
		})
		let edgesDescription = join(",\n", lazy(edges).map {
			"\t\t\($0)"
		})
		return "{\tnodes: (\n\(nodesDescription)\n\t);\n\tedges: (\n\(edgesDescription)\n\t);\n}"
	}


	// MARK: SequenceType

	public func generate() -> GeneratorOf<NodeView<T>> {
		let views = lazy(self.nodes).map { NodeView(graph: self, identifier: $0, value: $1) }
		var generator = views.generate()
		return GeneratorOf(generator)
	}


	// MARK: Private

	private mutating func sanitize(added: Set<Edge>) {
		if added.count == 0 { return }
		let keys = nodes.keys
		edges.subtractInPlace(lazy(added).filter {
			!contains(keys, $0.source.identifier) && !contains(keys, $0.destination.identifier)
		})
	}
}


public func == <T: Equatable> (left: Graph<T>, right: Graph<T>) -> Bool {
	return
		left.nodes == right.nodes
	&&	left.edges == right.edges
}


// MARK: - Imports

import Prelude
import Set
