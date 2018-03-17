//
//  ImageManager.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

// MARK: - Helper methodes

extension UIImageView {
    func set(imageByStringURL url: String?, placeholder: UIImage? = nil) {
        HTTPClient
                .shared
                .downloadImageOrSetPlaceholder(on: self, imageStringURL: url, placeholder: placeholder)
    }

    func set(imageByStringURL url: String?, placeholder: UIImage) {
        HTTPClient
                .shared
                .downloadImageOrSetPlaceholder(on: self, imageStringURL: url, placeholder: placeholder)
    }
}

class ImageManager: NSObject {
    
    // MARK: - Singleton
    
    static let shared = ImageManager()
    
    // MARK: - Private properties
    
    private var imageDownloader: ImageDownloader!
    private var imageCache: AutoPurgingImageCache!
    private var placeholderImage: UIImage!
    private let imageTransitionDuration: TimeInterval = 0.75
    
    // MARK: - Public properties
    
    var memoryImagesCapacityInMegaBytes: UInt64 = 150
    var memoryUsageAfterPurgeInMegaBytes: UInt64 = 60
    var maximumActiveDownloads = 5
    
    // MARK: - Initialization
    
    private override init() {
        super.init()

        imageCache = AutoPurgingImageCache(
                memoryCapacity: memoryImagesCapacityInMegaBytes * 1024 * 1024,
                preferredMemoryUsageAfterPurge: memoryUsageAfterPurgeInMegaBytes * 1024 * 1024
        )
        imageDownloader = ImageDownloader(
                configuration: ImageDownloader.defaultURLSessionConfiguration(),
                downloadPrioritization: .fifo,
                maximumActiveDownloads: maximumActiveDownloads,
                imageCache: imageCache
        )
        UIImageView.af_sharedImageDownloader = imageDownloader
    }

    // MARK: - Images download and set
    
    func setImageOrPlaceholder(onImageView imageView: UIImageView, stringURL: String?, placeholder: UIImage? = nil) {
        guard let correctURL = URL(string: stringURL!) else {
            debug(msg: "URL incorrect!: \(String(describing: stringURL))", isError: true)
            imageView.image = placeholder ?? self.placeholderImage
            return
        }
        let imageTransition: UIImageView.ImageTransition = .crossDissolve(imageTransitionDuration)
        imageView.af_setImage(withURL: correctURL,
                placeholderImage: nil, // placeholder ?? self.placeholderImage,
                filter: nil,
                imageTransition: imageTransition,
                completion: { response in
                })
    }

    func getImage(stringURL: String?, completion: @escaping (_ image: UIImage?, _ error: ImageError?) -> Void) {
        guard let correctURL = URL(string: stringURL!) else {
            debug(msg: "URL incorrect!: \(String(describing: stringURL))", isError: true)

            let err = ImageError(message: "URL incorrect!: \(String(describing: stringURL))")
            completion(nil, err)
            return
        }
        let urlRequest = URLRequest(url: correctURL)
        imageDownloader.download(urlRequest,
                receiptID: stringURL!,
                filter: nil) { response in
            if let image = response.result.value {
                completion(image, nil)
            } else {
                let message = response.result.error?.localizedDescription
                let statusCode = response.response?.statusCode
                let request = response.request
                let imageError = ImageError(message: message, alamofireCode: nil, httpCode: statusCode, requestURL: request)
                completion(nil, imageError)
            }
        }
    }

    func removeAllImagesFromCache() {
        if imageCache.removeAllImages() {
            debug(msg: "Removed ALL")
            return
        }
        debug(msg: "ERROR removeAllImagesFromCache", isError: true)
    }

    func debug(msg: String, isError: Bool = false) {
        if !isError {
            Log.warning(msg)
        } else {
            Log.error(msg)
        }
    }
}
