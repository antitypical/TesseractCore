//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Type {
	case Boolean
	case Function
	case Generic(Int, Box<Type>)
}


// MARK: - Imports

import Box
