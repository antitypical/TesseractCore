//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol DifferentiatorType {
	typealias Differentiable
	typealias Differential

	static func differentiate(#before: Differentiable, after: Differentiable) -> Differential
}
