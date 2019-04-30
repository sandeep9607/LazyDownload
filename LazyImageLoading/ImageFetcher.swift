//
//  Created by MOJAVE on 20/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

public typealias ImageDownloadCompletion = (UIImage?) -> Void

public final class ImageFetcher {
    
    public static let shared = ImageFetcher()
    
    let cache: Cache
    let downloader: Downloader
    
    /// Initialize a new instance of ImageFetcher.
    ///
    /// - Parameter cache: The cache to use. Uses the `default` instance if nothing is passed
    /// - Parameter downloader: The downloader to use. Users the `default` instance if nothing is passed
    init(cache: Cache = .default, downloader: Downloader = .default) {
        self.cache = cache
        self.downloader = downloader
    }
    
    /// Download or retrieve an image from cache
    ///
    /// - Parameters:
    ///     - url: The URL to load an image from
    ///     - transformer: An optional transformer or transformer chain to apply to the image
    ///     - progress: An optional closure to track the download progress
    ///     - completion: The closure to call once the download is done
    func image(with url: URL,
               progress: DownloadProgress?,
               completion: @escaping ImageDownloadCompletion) {
        fetchImage(with: url, progress: progress, completion: completion)
    }
    
    func fetchImage(with url: URL,
                    progress: DownloadProgress?,
                    completion: ImageDownloadCompletion?) {
        let key = url.absoluteString
        cache.retrieveImage(forKey: key) { [weak self] image, _ in
            guard let image = image else {
                self?.downloader.download(url, progress: progress, completion: { data in
                    guard let self = self, let data = data, let image = UIImage(data: data) else {
                        completion?(nil)
                        return
                    }
                    
                    self.cache.store(image, data: data, forKey: url.absoluteString)
                    completion?(image)
                })
                return
            }
            completion?(image)
        }
    }
    
    /// Pre-warms the image cache. Downloads the image if needed or loads it into memory.
    ///
    /// - Parameter url: The URL to load an image from
    public func preWarmCache(for url: URL) {
        fetchImage(with: url, progress: nil, completion: nil)
    }
    
}
