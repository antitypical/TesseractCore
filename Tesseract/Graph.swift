//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public init(_ source: SourceIdentifier, _ destination: DestinationIdentifier) {
		self.source = source
		self.destination = destination
	}

	public let source: SourceIdentifier
	public let destination: DestinationIdentifier


	// MARK: Hashable

	public var hashValue: Int {
		return source.hashValue ^ destination.hashValue
	}
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
}


public struct Graph<T> {
	public init(nodes: [Identifier: T] = [:], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
	}


	// MARK: Primitive methods

	public var nodes: [Identifier: T] {
		willSet {
			let removed = Set(nodes.keys) - Set(newValue.keys)
			if removed.count == 0 { return }
			edges = edges.filter {
				!removed.contains(containingIdentifier($0.source)) && !removed.contains(containingIdentifier($0.destination))
			}
		}
	}

	public var edges: Set<Edge> {
		didSet {
			let added = edges - oldValue
			if added.count == 0 { return }
			edges -= added.filter {
				!contains(self.nodes.keys, containingIdentifier($0.source)) && !contains(self.nodes.keys, containingIdentifier($0.destination))
			}
		}
	}
}

extension Dictionary {
	init<S: SequenceType where S.Generator.Element == Element>(_ elements: S) {
		self.init()
		var generator = elements.generate()
		let next: () -> Element? = { generator.next() }
		for (key, value) in GeneratorOf(next) {
			updateValue(value, forKey: key)
		}
	}
}


// MARK: - Imports

import Set
