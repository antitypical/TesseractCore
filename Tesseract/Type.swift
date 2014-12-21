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


func typeof(value: Value) -> Type {
	switch value {
	case .Boolean:
		return .Boolean
	case .Integer:
		return .Integer
	case .String:
		return .String
	}
}


// MARK: - Imports

import Box
