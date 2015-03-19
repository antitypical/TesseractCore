//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferentiator<T: Equatable> {
	public typealias Differential = (nodes: UnorderedDifferential<(Identifier, T)>, edges: UnorderedDifferential<Edge>)

	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> Differential {
		return Differential(nodes: DictionaryDifferentiator.differentiate(before: before.nodes, after: after.nodes), edges: SetDifferentiator.differentiate(before: before.edges, after: after.edges))
	}
}
