//  Copyright (c) 2015 Rob Rix. All rights reserved.

public protocol EndpointType {
	typealias Nodes: CollectionType

	var nodeIndex: Nodes.Index { get }
	var endpointIndex: Int { get }
}


public struct Source<C: CollectionType>: EndpointType, Printable {
	public init(nodeIndex: C.Index, outputIndex: Int = 0) {
		self.nodeIndex = nodeIndex
		self.outputIndex = outputIndex
	}

	public typealias Nodes = C
	public let nodeIndex: C.Index
	public let outputIndex: Int
	public var endpointIndex: Int { return outputIndex }


	public var description: String {
		return "Source(\(nodeIndex), \(outputIndex))"
	}
}

public struct Destination<C: CollectionType>: EndpointType, Printable {
	public init(nodeIndex: C.Index, inputIndex: Int = 0) {
		self.nodeIndex = nodeIndex
		self.inputIndex = inputIndex
	}

	public typealias Nodes = C
	public let nodeIndex: C.Index
	public let inputIndex: Int
	public var endpointIndex: Int { return inputIndex }


	public var description: String {
		return "Destination(\(nodeIndex), \(inputIndex))"
	}
}


public func == <E: EndpointType> (left: E, right: E) -> Bool {
	return
		left.nodeIndex == right.nodeIndex
	&&	left.endpointIndex == right.endpointIndex
}
