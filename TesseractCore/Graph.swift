//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Graph<C: CollectionType>: CollectionType, Printable {
	public init<S: SequenceType where S.Generator.Element == Edge<C>>(nodes: C, edges: S) {
		self.nodes = nodes
		self.edges = Set(edges)
		sanitize(self.edges)
	}

	public init(nodes: C) {
		self.init(nodes: nodes, edges: [])
	}

	public var nodes: C {
		willSet {
			let removed = lazy(indices(nodes)).filter { !contains(indices(newValue), $0) }.array
			if removed.count == 0 { return }
			edges = Set(lazy(edges).filter { edge in
				!contains(removed, { $0 == edge.source.nodeIndex || $0 == edge.destination.nodeIndex })
			})
		}
	}

	public var edges: Set<Edge<C>> {
		didSet {
			sanitize(edges.subtract(oldValue))
		}
	}


	// MARK: Higher-order methods

	public func map<U>(transform: Element -> U) -> Graph<[U]> {
		return Graph<[U]>(nodes: Swift.map(nodes, transform), edges: Set(lazy(edges).map {
			Edge<[U]>(Source(nodeIndex: Int(distance(self.nodes.startIndex, $0.source.nodeIndex).toIntMax()), outputIndex: $0.source.outputIndex), Destination(nodeIndex: Int(distance(self.nodes.startIndex, $0.destination.nodeIndex).toIntMax()), inputIndex: $0.destination.inputIndex))
		}))
	}


	public func reduce<Result>(from: Index, _ initial: Result, _ combine: (Result, Element) -> Result) -> Result {
		return reduce(from, [], initial, combine)
	}

	public func reduce<Result>(from: Index, var _ visited: [Index], _ initial: Result, _ combine: (Result, Element) -> Result) -> Result {
		if from == nodes.endIndex { return initial }

		if contains(visited, from) { return initial }
		visited.append(from)

		let node = nodes[from]
		let inputEdges = filter(edges) { $0.destination.nodeIndex == from }
		let inputs = sorted(inputEdges) { $0.destination.inputIndex < $1.destination.inputIndex }
			.map { $0.source.nodeIndex }
		return combine(Swift.reduce(inputs, initial) { into, each in
			self.reduce(each.0, visited, into, combine)
		}, node)
	}


	public func find(predicate: Element -> Bool) -> Index? {
		for index in nodes.startIndex..<nodes.endIndex {
			if predicate <| nodes[index] { return index }
		}
		return nil
	}


	// MARK: CollectionType

	public typealias Index = C.Index
	public typealias Element = C.Generator.Element

	public var startIndex: Index {
		return nodes.startIndex
	}

	public var endIndex: Index {
		return nodes.endIndex
	}

	public subscript(index: Index) -> Element {
		return nodes[index]
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

	public func generate() -> IndexingGenerator<Graph> {
		return IndexingGenerator(self)
	}


	// MARK: Private

	private mutating func sanitize(added: Set<Edge<C>>) {
		if added.count == 0 { return }
		let extant = indices(nodes)
		edges.subtractInPlace(lazy(added).filter { edge in
			!contains(extant, { $0 == edge.source.nodeIndex || $0 == edge.destination.nodeIndex })
		})
	}
}


public func == <C: CollectionType where C.Generator.Element: Equatable> (left: Graph<C>, right: Graph<C>) -> Bool {
	return
		count(left.nodes) == count(right.nodes)
	&&	reduce(lazy(zip(left.nodes, right.nodes)).map { $0 == $1 }, true, { $0 && $1 })
	&&	left.edges == right.edges
}


// MARK: - Imports

import Prelude
import Set
