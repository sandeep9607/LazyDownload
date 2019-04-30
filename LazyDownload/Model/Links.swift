//
//  Links.swift
//
//  Created by SANCHI on 30/04/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class Links {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let download = "download"
    static let html = "html"
  }

  // MARK: Properties
  public var download: String?
  public var html: String?


  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    download = json[SerializationKeys.download].string
    html = json[SerializationKeys.html].string
  }

}
