//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func exportDOT<T: Printable>(graph: Graph<T>) -> String {
    let edges = join("\n", lazy(graph.edges).map { edge in
        let sourceID = edge.source.identifier
        let destinationID = edge.destination.identifier
        let source = graph.nodes[sourceID]
        let destination = graph.nodes[destinationID]
        let sourceDescription = source.map { $0.description } ?? ""
        let destinationDescription = destination.map { $0.description } ?? ""
        return "\t\"" + sourceDescription + "\" -> \"" + destinationDescription + "\";"
    })
    return "digraph tesseract {\n\(edges)\n}"
}


// MARK: - Imports

import Prelude
