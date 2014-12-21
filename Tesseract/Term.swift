//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Term {
	case Parameter(String, Type)
	case Return(String, Type)

	case Constant(Value)
}


enum Value {
	case Boolean(Swift.Bool)
	case Integer(Swift.Int)
	case String(Swift.String)
}
