//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Type {
	case Boolean
	case Function
	case Generic(Int, Box<Type>)
	case Parameter(Int)
}


// MARK: - Imports

import Box
