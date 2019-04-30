//
//  ProfileImage.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class ProfileImage {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let large = "large"
    static let small = "small"
    static let medium = "medium"
  }

  // MARK: Properties
  public var large: String?
  public var small: String?
  public var medium: String?


  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    large = json[SerializationKeys.large].string
    small = json[SerializationKeys.small].string
    medium = json[SerializationKeys.medium].string
  }

}
