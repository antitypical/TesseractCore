//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func export<T>(graph: Graph<T>) -> String {
	return
		"digraph tesseract {\n"
	+	reduce(graph.edges, "") {
			$0 + "\t" + $1.source.identifier.description + " -> " + $1.destination.identifier.description + ";\n"
		}
	+	"}"
}


// MARK: - Imports

import Prelude
