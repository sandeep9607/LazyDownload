//
//  Created by MOJAVE on 20/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

public typealias DownloadProgress = (_ received: Int64, _ total: Int64) -> Void
public typealias DownloadCompletion = (Data?) -> Void

protocol DownloadStateDelegate: AnyObject {

  func progress(for url: URL) -> DownloadProgress?
  func completions(for url: URL) -> [DownloadCompletion]?
  func clearDownload(for url: URL?)
  func download(for url: URL) -> Download?

}

class Download {

  let task: URLSessionDataTask
  let progress: DownloadProgress?
  var completions: [DownloadCompletion]
  var data: Data
  var backgroundTask: UIBackgroundTaskIdentifier = .invalid

  init(task: URLSessionDataTask, progress: DownloadProgress?, completion: @escaping DownloadCompletion,
       data: Data) {
    self.task = task
    self.progress = progress
    self.completions = [completion]
    self.data = data
  }

  func start() {
    backgroundTask = UIApplication.shared.beginBackgroundTask {
      self.invalidateBackgroundTask()
    }
  }

  func finish() {
    invalidateBackgroundTask()
  }

  private func invalidateBackgroundTask() {
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = .invalid
  }
}

/// The class responsible for downloading data. Access it through the `default` singleton.
class Downloader {

  /// The default `Downloader` singleton
  public static let `default` = Downloader()

  let mutex: DispatchQueue
  let sessionDelegate: SessionDelegate
  let session: URLSession

  var downloads: [URL: Download]

  public init(sessionConfiguration: URLSessionConfiguration = .default) {
    mutex = DispatchQueue(label: "com.sanchi.Downloader.mutex", attributes: .concurrent)
    sessionDelegate = SessionDelegate()
    session = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: .main)
    downloads = [:]
  }

  /// Download an asset.
  ///
  /// - Parameters
  ///     - url: The URL to download from
  ///     - progress: An optional download progress closure
  ///     - completion: The completion closure called once the download is done
  public func download(_ url: URL, progress: DownloadProgress? = nil, completion: @escaping DownloadCompletion) {
    sessionDelegate.delegate = self

    mutex.sync(flags: .barrier) {
      let task: URLSessionDataTask
      if let download = downloads[url] {
        task = download.task
        download.completions.append(completion)
      } else {
        let newTask = session.dataTask(with: url)
        let download = Download(task: newTask, progress: progress, completion: completion, data: Data())
        download.start()
        downloads[url] = download
        task = newTask
      }

      task.resume()
    }
  }

}

extension Downloader: DownloadStateDelegate {

    func progress(for url: URL) -> DownloadProgress? {
    return downloads[url]?.progress
  }

  func completions(for url: URL) -> [DownloadCompletion]? {
    return downloads[url]?.completions
  }

  func clearDownload(for url: URL?) {
    guard let url = url else { return }
    mutex.sync(flags: .barrier) {
      downloads[url] = nil
    }
  }

  func download(for url: URL) -> Download? {
    var download: Download?
    mutex.sync(flags: .barrier) {
      download = downloads[url]
    }
    return download
  }

}

class SessionDelegate: NSObject, URLSessionDataDelegate {

  weak var delegate: DownloadStateDelegate?

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    guard let url = dataTask.originalRequest?.url,
          let download = delegate?.download(for: url),
          let total = dataTask.response?.expectedContentLength else {
            return
    }
    download.data.append(data)
    delegate?.progress(for: url)?(numericCast(download.data.count), total)
  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let url = task.originalRequest?.url,
          let download = delegate?.download(for: url) else {
            return
    }

    let data = error == nil ? download.data : nil
    delegate?.completions(for: url)?.forEach { completion in
      completion(data)
    }
    delegate?.clearDownload(for: url)
    download.finish()
  }

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                  willCacheResponse proposedResponse: CachedURLResponse,
                  completionHandler: @escaping (CachedURLResponse?) -> Void) {
    completionHandler(nil)
  }

}
