//  Copyright (c) 2015 Rob Rix. All rights reserved.

public enum Type {
	public init(function from: Type, _ to: Type) {
		self = Function(Box(from), Box(to))
	}


	case Parameter(Int)
	case Function(Box<Type>, Box<Type>)
}


// MARK: - Imports

import Box
