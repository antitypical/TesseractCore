//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Binding]

public let Prelude: Environment = [
	Symbol(name: "identity", parameters: 1, returns: 1): .Function(.Parameter(0), .Parameter(0), id),
]

public enum Binding {
	case Constant(Type, Any)
	case Function(Type, Type, Any -> Any)
}


// MARK: - Imports

import Prelude
