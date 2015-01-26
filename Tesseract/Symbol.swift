//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Symbol: Hashable {
	public let name: String
	public let parameters: Int
	public let returns: Int


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	parameters
		^	returns
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	return
		left.name == right.name
	&&	left.parameters == right.parameters
	&&	left.returns == right.returns
}
