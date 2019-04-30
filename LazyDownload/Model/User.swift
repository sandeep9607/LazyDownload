//
//  User.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class User {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let profileImage = "profile_image"
    static let links = "links"
    static let name = "name"
    static let id = "id"
    static let username = "username"
  }

  // MARK: Properties
  public var profileImage: ProfileImage?
  public var links: Links?
  public var name: String?
  public var id: String?
  public var username: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    profileImage = ProfileImage(json: json[SerializationKeys.profileImage])
    links = Links(json: json[SerializationKeys.links])
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].string
    username = json[SerializationKeys.username].string
  }

}
