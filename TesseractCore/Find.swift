//  Copyright (c) 2015 Rob Rix. All rights reserved.

public func find<C: CollectionType>(domain: C, @noescape predicate: C.Generator.Element -> Bool) -> C.Index? {
	for index in domain.startIndex..<domain.endIndex {
		if predicate(domain[index]) { return index }
	}
	return nil
}
