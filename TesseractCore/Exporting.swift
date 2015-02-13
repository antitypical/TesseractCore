//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T>(graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map { edge in
		"\t\"\(graph.nodes[edge.source.identifier]!)\" -> \"\(graph.nodes[edge.destination.identifier]!)\";"
	})
	return "digraph tesseract {\n\(edges)\n}"
}


// MARK: - Imports

import Prelude
