//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func export<T>(graph: Graph<T>) -> String {
    var result = "digraph tesseract {\n"
	result += reduce(graph.edges, "") {
		$0 + "\t" + $1.source.identifier.description + " -> " + $1.destination.identifier.description + ";\n"
	}
    result += "}"
    return result
}


// MARK: - Imports

import Prelude
