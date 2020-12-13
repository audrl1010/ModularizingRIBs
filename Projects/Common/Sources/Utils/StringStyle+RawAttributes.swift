//
//  StringStyle+RawAttributes.swift
//  Common
//
//  Created by myunggison on 12/13/20.
//

import BonMot

public extension StringStyle {
  var rawAttributes: [NSAttributedString.Key: Any] {
    return self.attributes.reduce(into: [:]) { result, attribute in
      result[attribute.key] = attribute.value
    }
  }
  var rawStrings: [String: Any] {
    return self.attributes.reduce(into: [:]) { result, attribute in
      result[attribute.key.rawValue] = attribute.value
    }
  }
}
