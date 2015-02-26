//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(name: String, graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map { edge in
		let source = graph.nodes[edge.source.identifier]
		let destination = graph.nodes[edge.destination.identifier]
		let sourceDescription = source.map(toString) ?? ""
		let destinationDescription = destination.map(toString) ?? ""
		return "\t\"\(sourceDescription)\" -> \"\(destinationDescription)\" [sametail=\(edge.source.outputIndex),headlabel=\(edge.destination.inputIndex)];"
	})
	return "digraph \(name) {\n\(edges)\n}"
}


// MARK: - Imports

import Prelude
