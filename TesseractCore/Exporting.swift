//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func export<T>(graph: Graph<T>) -> String {
	return
		"digraph tesseract {\n"
	+	join("", lazy(graph.edges).map { "\t" + $0.source.identifier.description + " -> " + $0.destination.identifier.description + ";\n" })
	+	"}"
}


// MARK: - Imports

import Prelude
