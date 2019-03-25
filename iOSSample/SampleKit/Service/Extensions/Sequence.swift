//
//  Sequence.swift
//  ServicePlatform
//
//

import Foundation

public extension Sequence {

  public func categorise<U, E>(dict: inout [U:[E]], _ key: (Iterator.Element) -> U, _ element: (Iterator.Element) -> E) {
    for el in self {
      let key = key(el)
      if case nil = dict[key]?.append(element(el)) { dict[key] = [element(el)] }
    }
  }

  public func find(_ find: (Iterator.Element) -> Bool) -> Iterator.Element? {
    for it in self where find(it) { return it }
    return nil
  }

  public func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
    var categories: [U: [Iterator.Element]] = [:]
    for element in self {
      let key = key(element)
      if case nil = categories[key]?.append(element) {
        categories[key] = [element]
      }
    }
    return categories
  }
}

// MARK: - Array
public extension Array {

  // MARK: - Custom functions
  public func findRev(_ find: (Element) -> Bool) -> Element? {
    for it in self.reversed() where find(it) { return it }
    return nil
  }

  public func unique(filter: ([Element], Element) -> Bool) -> [Element] {
    return reduce([], { (res, item) in !filter(res, item) ? res + [item] : res })
  }

  public func find(_ find: (Element) -> Bool) -> Element? {
    for it in self where find(it) { return it }
    return nil
  }
}

public extension Array where Element: Equatable {

  public func contains(_ objs: [Element]) -> Bool {
    return !objs.contains { !self.contains($0) }
  }

  public func containsAnyOf(_ objs: [Element]) -> Bool {
    for it in objs where self.contains(it) { return true }
    return false
  }
}
