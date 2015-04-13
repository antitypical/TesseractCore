//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct GraphDifferentiator<C: CollectionType where C.Generator.Element: Equatable, C.Index.Distance: SignedIntegerType> {
	public typealias Differential = (nodes: ForwardDifferential<C.Index.Distance, C.Generator.Element>, edges: UnorderedDifferential<Edge<C>>)

	public static func differentiate(#before: Graph<C>, after: Graph<C>) -> Differential {
		return Differential(nodes: ForwardDifferential.differentiate(before: before.nodes, after: after.nodes) { $0 == $1 }, edges: SetDifferentiator.differentiate(before: before.edges, after: after.edges))
	}
}
