//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Type {
	case Boolean
	case Integer
	case String

	case Function(Box<Type>, Box<Type>)

	case Generic(Int, Box<Type>)
	case Parameter(Int)

	case Sum([Type])
	case Product([Type])
}


// MARK: - Imports

import Box
