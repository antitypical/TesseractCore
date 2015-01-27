//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Value]

public let Prelude: Environment = [
	Symbol(name: "identity", parameters: 1, returns: 1): .Function(.Parameter(0), .Parameter(0), id),
	Symbol(name: "const", parameters: 1, returns: 1): .Function(.Parameter(0), Type(function: .Parameter(1), .Parameter(0)), const as Any -> Any -> Any),
	Symbol(name: "unit", parameters: 0, returns: 1): .Constant(.Unit, ()),
]


public func evaluate(graph: Graph<Node>, from: Identifier, environment: Environment = Prelude) -> Either<(Identifier, String), Value> {
	return .left(from, "unimplemented")
}


// MARK: - Imports

import Either
import Prelude
