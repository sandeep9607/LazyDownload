//
//  PostModel.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class PostModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let height = "height"
    static let user = "user"
    static let id = "id"
    static let categories = "categories"
    static let likes = "likes"
    static let createdAt = "created_at"
    static let width = "width"
    static let urls = "urls"
    static let currentUserCollections = "current_user_collections"
    static let links = "links"
    static let likedByUser = "liked_by_user"
    static let color = "color"
  }

  // MARK: Properties
  public var height: Int?
  public var user: User?
  public var id: String?
  public var categories: [Categories]?
  public var likes: Int?
  public var createdAt: String?
  public var width: Int?
  public var urls: Urls?
  public var currentUserCollections: [Any]?
  public var links: Links?
  public var likedByUser: Bool? = false
  public var color: String?


  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    height = json[SerializationKeys.height].int
    user = User(json: json[SerializationKeys.user])
    id = json[SerializationKeys.id].string
    if let items = json[SerializationKeys.categories].array { categories = items.map { Categories(json: $0) } }
    likes = json[SerializationKeys.likes].int
    createdAt = json[SerializationKeys.createdAt].string
    width = json[SerializationKeys.width].int
    urls = Urls(json: json[SerializationKeys.urls])
    if let items = json[SerializationKeys.currentUserCollections].array { currentUserCollections = items.map { $0.object} }
    links = Links(json: json[SerializationKeys.links])
    likedByUser = json[SerializationKeys.likedByUser].boolValue
    color = json[SerializationKeys.color].string
  }


}
