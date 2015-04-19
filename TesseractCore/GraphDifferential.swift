//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferential<C: CollectionType where C.Index: Hashable> {
	public init(nodes: UnorderedDifferential<(C.Index, C.Generator.Element)>, edges: UnorderedDifferential<Edge<C>>) {
		self.nodes = nodes
		self.edges = edges
	}

	public let nodes: UnorderedDifferential<(C.Index, C.Generator.Element)>
	public let edges: UnorderedDifferential<Edge<C>>


	public var inverse: GraphDifferential {
		return GraphDifferential(nodes: nodes.inverse, edges: edges.inverse)
	}


	// MARK: Differentiation

	public static func differentiate(#before: Graph<C>, after: Graph<C>, equals: (C.Generator.Element, C.Generator.Element) -> Bool) -> GraphDifferential {
		let nodes = DictionaryDifferentiator.differentiate(before: Dictionary(zip(indices(before.nodes), before.nodes)), after: Dictionary(zip(indices(after.nodes), after.nodes)), equals: equals)
		return GraphDifferential(nodes: nodes, edges: SetDifferentiator.differentiate(before: before.edges, after: after.edges))
	}

	public static func patch(graph: Graph<C>, equals: (C.Generator.Element, C.Generator.Element) -> Bool, transform: Graph<C> -> Graph<C>) -> GraphDifferential {
		return differentiate(before: graph, after: transform(graph), equals: equals)
	}
}


public func patch<C: RangeReplaceableCollectionType where C.Index: Comparable>(diff: GraphDifferential<C>, var graph: Graph<C>) -> Graph<C> {
	graph.nodes = patch(diff.nodes, graph.nodes)
	graph.edges = patch(diff.edges, graph.edges)
	return graph
}
