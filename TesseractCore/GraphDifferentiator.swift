//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferentiator<C: CollectionType where C.Index: Hashable> {
	public typealias Differential = (nodes: UnorderedDifferential<(C.Index, C.Generator.Element)>, edges: UnorderedDifferential<Edge<C>>)

	public static func differentiate(#before: Graph<C>, after: Graph<C>, equals: (C.Generator.Element, C.Generator.Element) -> Bool) -> Differential {
		let nodes = DictionaryDifferentiator.differentiate(before: Dictionary(zip(indices(before.nodes), before.nodes)), after: Dictionary(zip(indices(after.nodes), after.nodes)), equals: equals)
		return Differential(nodes: nodes, edges: SetDifferentiator.differentiate(before: before.edges, after: after.edges))
	}
}
