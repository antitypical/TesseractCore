//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferentiator<T: Equatable> {
	public let nodes: UnorderedDifferential<(Identifier, T)>
	public let edges: UnorderedDifferential<Edge>


	public static func differentiate(#before: Graph<T>, after: Graph<T>) -> GraphDifferentiator {
		return GraphDifferentiator(nodes: DictionaryDifferentiator.differentiate(before: before.nodes, after: after.nodes), edges: SetDifferentiator.differentiate(before: before.edges, after: after.edges))
	}
}
