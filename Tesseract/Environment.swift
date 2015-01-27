//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Binding]

public let Prelude: Environment = [:]

public enum Binding {
	case Constant(Type, Any)
	case Function(Type, Type, Any -> Any)
}
