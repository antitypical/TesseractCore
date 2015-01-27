//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Binding]

public let Prelude: Environment = [
	Symbol(name: "identity", parameters: 1, returns: 1): .Function(.Parameter(0), .Parameter(0), id),
]


// MARK: - Imports

import Prelude
