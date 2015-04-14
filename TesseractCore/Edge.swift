//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Edge<C: CollectionType>: Hashable, Printable {
	public init(_ source: Source<C>, _ destination: Destination<C>) {
		self.source = source
		self.destination = destination
	}

	public init (_ source: C.Index, _ destination: Destination<C>) {
		self.init(Source(nodeIndex: source, outputIndex: 0), destination)
	}

	public let source: Source<C>
	public let destination: Destination<C>


	// MARK: Hashable

	public var hashValue: Int {
		return source.description.hashValue ^ destination.description.hashValue
	}

	
	// MARK: Printable
	
	public var description: String {
		return "\(source.nodeIndex): \(source.outputIndex) -> \(destination.nodeIndex): \(destination.inputIndex)"
	}
}

public func == <C: CollectionType> (left: (C.Index, Int), right: (C.Index, Int)) -> Bool {
	return left.0 == right.0 && left.1 == right.1
}

public func == <C: CollectionType> (left: Edge<C>, right: Edge<C>) -> Bool {
	return
		left.source.nodeIndex == right.source.nodeIndex && left.source.outputIndex == right.source.outputIndex
	&&	left.destination.nodeIndex == right.destination.nodeIndex && left.destination.inputIndex == right.destination.inputIndex
}
