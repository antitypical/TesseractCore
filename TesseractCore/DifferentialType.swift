//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol DifferentialType {
	typealias Differentiable

	static func differentiate(#before: Differentiable, after: Differentiable) -> Self
}
