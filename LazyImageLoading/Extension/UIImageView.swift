//
//  Created by MOJAVE on 20/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

extension UIImageView {
  
  /// Set image on self from a URL
  ///
  /// - Parameters:
  ///     - url: The URL to load an image from
  ///     - placeholder: An optional placeholder image to set while loading
  ///     - progress: An optional closure to track the download progress
  ///     - completion: An optional closure to call once the download is done
  public func setImage(with url: URL?,
                       placeholder: UIImage? = nil,
                       progress: DownloadProgress? = nil,
                       completion: ImageDownloadCompletion? = nil) {
    imageUrl = url
    image = placeholder
    guard let url = url else {
      completion?(nil)
      return
    }

    ImageFetcher.shared.image(with: url, progress: progress) { [weak self] image in
      guard let self = self, self.imageUrl == url else { return }
      self.image = image
      completion?(image)
    }
  }

  private var imageUrl: URL? {
    get {
      return objc_getAssociatedObject(self, &imageUrlKey) as? URL
    }
    set {
      objc_setAssociatedObject(self, &imageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

}

private var imageUrlKey: UInt8 = 0
