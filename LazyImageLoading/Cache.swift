//
//  Created by MOJAVE on 20/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

public enum CacheType {
  case none, memory
}

/// The class responsible for caching images. Images will be cached  in memory.
public final class Cache {
  
  private static let prefix = "com.sanchi.Cache."

  /// The default `Cache` singleton
  public static let `default` = Cache(name: "default")

  public let cachePath: String
  
  private let memory = NSCache<NSString, AnyObject>()

  /// Construct a new instance of the cache
  ///
  /// - Parameter name: The name of the cache. Used to construct a unique path
  public init(name: String) {
    let cacheName = Cache.prefix + name
    memory.name = cacheName

    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    cachePath = (path as NSString).appendingPathComponent(name)

    NotificationCenter.default.addObserver(self, selector: #selector(clearMemory),
                                           name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
  }

  /// Stores an image in the cache. Images will be added to memory
  ///
  /// - Parameters
  ///     - image: The image to cache
  ///     - key: The unique identifier of the image
  public func store(_ image: UIImage, data: Data? = nil, forKey key: String,
                    completion: (() -> Void)? = nil) {
    memory.setObject(image, forKey: key as NSString)
  }

  /// Retrieve an image from cache.
  ///
  /// - Parameters
  ///     - key: The unique identifier of the image
  ///     - completion: The completion called once the image has been retrieved from the cache
  public func retrieveImage(forKey key: String, completion: (UIImage?, CacheType) -> Void) {
    if let image = memory.object(forKey: key as NSString) as? UIImage {
      completion(image, .memory)
      return
    }

    completion(nil, .none)
  }
  
  @objc
  public func clearMemory() {
    memory.removeAllObjects()
  }
}
