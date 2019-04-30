//
//  Urls.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class Urls {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let full = "full"
    static let small = "small"
    static let thumb = "thumb"
    static let regular = "regular"
    static let raw = "raw"
  }

  // MARK: Properties
  public var full: String?
  public var small: String?
  public var thumb: String?
  public var regular: String?
  public var raw: String?


  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    full = json[SerializationKeys.full].string
    small = json[SerializationKeys.small].string
    thumb = json[SerializationKeys.thumb].string
    regular = json[SerializationKeys.regular].string
    raw = json[SerializationKeys.raw].string
  }

}
