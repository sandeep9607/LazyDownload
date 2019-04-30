//
//  Categories.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class Categories {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let title = "title"
    static let photoCount = "photo_count"
    static let id = "id"
    static let links = "links"
  }

  // MARK: Properties
  public var title: String?
  public var photoCount: Int?
  public var id: Int?
  public var links: Links?


  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    title = json[SerializationKeys.title].string
    photoCount = json[SerializationKeys.photoCount].int
    id = json[SerializationKeys.id].int
    links = Links(json: json[SerializationKeys.links])
  }

}
