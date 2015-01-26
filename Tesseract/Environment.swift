//  Copyright (c) 2015 Rob Rix. All rights reserved.

public typealias Environment = [Symbol: Binding]

public enum Binding {
	case Constant(Any)
	case Function(Any -> Any)
}
