//  Copyright (c) 2015 Rob Rix. All rights reserved.

// MARK: Edge

public func == <C: CollectionType> (left: Edge<C>, right: Edge<C>) -> Bool {
	return
		left.source.nodeIndex == right.source.nodeIndex && left.source.outputIndex == right.source.outputIndex
	&&	left.destination.nodeIndex == right.destination.nodeIndex && left.destination.inputIndex == right.destination.inputIndex
}


// MARK: Endpoint

public func == <E: EndpointType> (left: E, right: E) -> Bool {
	return
		left.nodeIndex == right.nodeIndex
	&&	left.endpointIndex == right.endpointIndex
}


// MARK: Graph

public func == <C: CollectionType where C.Generator.Element: Equatable> (left: Graph<C>, right: Graph<C>) -> Bool {
	return Graph.equals { $0 == $1 } (left, right)
}


// MARK: Node

public func == (left: Node, right: Node) -> Bool {
	switch (left, right) {
	case let (.Parameter(x1, x2), .Parameter(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Return(x1, x2), .Return(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Symbolic(x), .Symbolic(y)):
		return x == y
	case let (.Literal(x1, x2), .Literal(y1, y2)):
		return x1 == y1 && x2 == y2

	default:
		return false
	}
}


// MARK: Symbol

public func == (left: Symbol, right: Symbol) -> Bool {
	switch (left, right) {
	case let (.Named(x1, x2), .Named(y1, y2)):
		return x1 == y1 && x2 == y2
	case let (.Index(x1, x2), .Index(y1, y2)):
		return x1 == y1 && x2 == y2
	default:
		return false
	}
}


// MARK: TypeDifferential

public func == (left: TypeDifferential, right: TypeDifferential) -> Bool {
	switch (left, right) {
	case let (.Patch(p1, p2), .Patch(q1, q2)):
		return p1 == q1 && p2 == q2
	case let (.Copy(t), .Copy(u)):
		return t == u
	default:
		return false
	}
}


// MARK: Value

/// Value equality.
///
/// Two values are equal if their state is of the same known equatable type and equal, or if they have the same name.
///
/// “Known equatable types” currently include:
///
/// - Bool
/// - Void
/// - Graph
public func == (left: Value, right: Value) -> Bool {
	if let a = left.constant(Bool.self), b = right.constant(Bool.self) {
		return a == b
	} else if let a: () = left.constant(Void.self), b: () = right.constant(Void.self) {
		return true
	} else if let a = left.graph, b = right.graph {
		return a == b
	}
	switch (left, right) {
	case let (.Named(a, _), .Named(b, _)):
		return a == b
	default:
		return false
	}
}


import Manifold
