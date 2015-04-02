//  Copyright (c) 2015 Rob Rix. All rights reserved.

let absoluteValue = Graph<String>(nodes: [
	"x",
	"result",
	"0",
	"unaryMinus",
	"if",
	"lessThan"
], edges: [
	Edge(0, Identifier(5).input(0)),
	Edge(2, Identifier(5).input(1)),
	Edge(5, Identifier(4).input(0)),
	Edge(0, Identifier(3).input(0)),
	Edge(3, Identifier(5).input(1)),
	Edge(0, Identifier(4).input(2)),
	Edge(4, Identifier(1).input(0))
])


// MARK: - Imports

import TesseractCore
