//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func export<T>(graph: Graph<T>) -> String {
    var result = "digraph tesseract {\n"
    result += reduce(map(graph.edges, { edge in "\t" + edge.source.identifier.description + " -> " + edge.destination.identifier.description + ";\n" }), "", +)
    result += "}"
    return result
}


// MARK: - Imports

import Prelude
