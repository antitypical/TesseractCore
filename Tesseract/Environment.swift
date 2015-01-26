//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Binding]

public let Prelude: Environment = [:]

public enum Binding {
	case Constant(Any)
	case Function(Any -> Any)
}
