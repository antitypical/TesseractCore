//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Symbol: Hashable {
	public let name: String
	public let parameters: [String]
	public let returns: [String]


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	parameters.reduce(0) { $0 ^ $1.hashValue }
		^	returns.reduce(0) { $0 ^ $1.hashValue }
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	return
		left.name == right.name
	&&	left.parameters == right.parameters
	&&	left.returns == right.returns
}
