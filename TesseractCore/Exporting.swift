//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func export<T>(graph: Graph<T>) -> String {
	let edges = join("\n", lazy(graph.edges).map { "\t" + $0.source.identifier.description + " -> " + $0.destination.identifier.description + ";" })
	return "digraph tesseract {\n\(edges)\n}"
}


// MARK: - Imports

import Prelude
