//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type {
	case Parameter(Int)
	case Function(Box<Type>, Box<Type>)
}


// MARK: - Imports

import Box
