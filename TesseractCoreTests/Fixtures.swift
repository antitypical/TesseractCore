//  Copyright (c) 2015 Rob Rix. All rights reserved.

let absoluteValue = Graph<[String]>(nodes: [
	"x",
	"result",
	"0",
	"unaryMinus",
	"if",
	"lessThan"
], edges: [
	Edge(0, (5, 0)),
	Edge(2, (5, 1)),
	Edge(5, (4, 0)),
	Edge(0, (3, 0)),
	Edge(3, (5, 1)),
	Edge(0, (4, 2)),
	Edge(4, (1, 0))
])


// MARK: - Imports

import TesseractCore
