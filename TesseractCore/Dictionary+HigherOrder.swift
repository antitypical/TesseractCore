//  Copyright (c) 2015 Rob Rix. All rights reserved.

extension Dictionary {
	init<S: SequenceType where S.Generator.Element == Element>(_ elements: S) {
		self.init()
		var generator = elements.generate()
		let next: () -> Element? = { generator.next() }
		for (key, value) in GeneratorOf(next) {
			updateValue(value, forKey: key)
		}
	}

	func filter(includeKeyAndValue: Element -> Bool) -> Dictionary {
		return Dictionary(lazy(self).filter(includeKeyAndValue))
	}

	func map<K: Hashable, V>(transform: Element -> (K, V)) -> Dictionary<K, V> {
		return Dictionary<K, V>(lazy(self).map(transform))
	}

	func flatMap<K: Hashable, V, S: SequenceType where S.Generator.Element == Dictionary<K, V>.Element>(transform: Element -> S) -> Dictionary<K, V> {
		return reduce(Dictionary<K, V>(minimumCapacity: count)) {
			$0 + transform($1)
		}
	}

	func reduce<Into>(initial: Into, combine: (Into, Element) -> Into) -> Into {
		return Swift.reduce(self, initial, combine)
	}
}


func + <Key: Hashable, Value, S: SequenceType where S.Generator.Element == Dictionary<Key, Value>.Element> (var left: Dictionary<Key, Value>, right: S) -> Dictionary<Key, Value> {
	var generator = right.generate()
	let next: () -> (Key, Value)? = { generator.next() }
	for (key, value) in GeneratorOf(next) {
		left.updateValue(value, forKey: key)
	}
	return left
}

func + <Key: Hashable, Value: Hashable> (var left: Dictionary<Key, Set<Value>>, right: (Key, Value)) -> Dictionary<Key, Set<Value>> {
	let set: Set<Value> = [right.1]
	left[right.0] = left[right.0]?.union(set) ?? set
	return left
}
