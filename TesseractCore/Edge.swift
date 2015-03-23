//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Edge: Hashable, Printable {
	public typealias Source = (identifier: Identifier, outputIndex: Int)
	public typealias Destination = (identifier: Identifier, inputIndex: Int)

	public init(_ source: Source, _ destination: Destination) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: Identifier, _ destination: Destination) {
		self.init(source.output(0), destination)
	}

	public let source: Source
	public let destination: Destination


	// MARK: Hashable

	public var hashValue: Int {
		return (source.identifier.hashValue + source.outputIndex) ^ (destination.identifier.hashValue + destination.inputIndex)
	}

	
	// MARK: Printable
	
	public var description: String {
		return "\(source.identifier): \(source.outputIndex) -> \(destination.identifier): \(destination.inputIndex)"
	}
}

public func == (left: (Identifier, Int), right: (Identifier, Int)) -> Bool {
	return left.0 == right.0 && left.1 == right.1
}

public func < (left: (Identifier, Int), right: (Identifier, Int)) -> Bool {
	return left.0 == right.0 ?
		left.1 < right.1
	:	left.0 < right.0
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
}
