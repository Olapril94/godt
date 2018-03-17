//
//  HTTPClient.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import ObjectMapper
import Alamofire


class HTTPClient: NSObject {

    // MARK: - Singleton

    static let shared = HTTPClient()

    // MARK: - Private attributes

    private var manager: Alamofire.SessionManager

    // MARK: - Private constants

    fileprivate let timeoutIntervalForRequest: Double = 15
    fileprivate let timeoutIntervalForResource: Double = 20
    fileprivate let maximumImagesActiveDownloads = 8
    fileprivate let memoryImagesCapacityInMegaBytes: UInt64 = 250
    fileprivate let memoryImagesUsageAfterPurgeInMegaBytes: UInt64 = 150

    // MARK: - Initialization
    
    private override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        manager = Alamofire.SessionManager(configuration: configuration)
        
        super.init()
    }

    private func showNetworkActivityIndicator(visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
}

// MARK: - Communication

extension HTTPClient {
    func responseCollection<E: Mappable>(router: URLRequestConvertible,
                                         completion: @escaping (_ entities: [E]?, _ error: ResponseError?) -> Void) {
        UserAuthManager.shared.loadCookies()
        
        showNetworkActivityIndicator(visible: true)

        let request = manager.request(router)
        let queue = DispatchQueue(label: "get-queue", attributes: .concurrent)
        Log.debug(request.request?.url?.absoluteString)

        request.response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
                completionHandler: { response in
                    let httpCode = response.response?.statusCode ?? 0

                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            if let responseCollection = Mapper<E>().mapArray(JSONObject: value), (200...299).contains(httpCode) {
                                completion(responseCollection, nil)
                            } else {
                                let responseError = ResponseError(httpCode: httpCode, json: value as! [String: AnyObject])
                                completion(nil, responseError)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            let responseError = ResponseError(httpCode: httpCode, error: error)
                            completion(nil, responseError)
                        }
                    }
                })
    }

    func responseCollection<P: Mappable, E: Mappable>(router: URLRequestConvertible,
                                                      completion: @escaping (_ pagination: P?, _ entities: [E]?, _ error: ResponseError?) -> Void) {
        showNetworkActivityIndicator(visible: true)

        let request = manager.request(router)
        let queue = DispatchQueue(label: "get-queue", attributes: .concurrent)
        Log.debug(request.request?.url?.absoluteString)

        request.response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
                completionHandler: { response in
                    let httpCode = response.response?.statusCode ?? 0

                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            let pagination = Mapper<P>().map(JSONObject: value)
                            guard let json = value as? [String: AnyObject] else {
                                completion(pagination, nil, ResponseError(httpCode: httpCode, json: [:]))
                                return
                            }

                            if let arr = json["content"], let collection = Mapper<E>().mapArray(JSONObject: arr), (200...299).contains(httpCode) {
                                completion(pagination, collection, nil)
                            } else if let collection = Mapper<E>().mapArray(JSONObject: value), (200...299).contains(httpCode) {
                                completion(pagination, collection, nil)
                            } else {
                                let responseError = ResponseError(httpCode: httpCode, json: json)
                                completion(pagination, nil, responseError)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            let responseError = ResponseError(httpCode: httpCode, error: error)
                            completion(nil, nil, responseError)
                        }
                    }
                })
    }

    func responseObject<E: Mappable>(router: URLRequestConvertible,
                                     completion: @escaping (_ entity: E?, _ error: ResponseError?) -> Void) {
        let request = manager.request(router)
        let queue = DispatchQueue(label: "get", attributes: .concurrent)

        Log.debug(request.request?.url?.absoluteString)

        showNetworkActivityIndicator(visible: true)
        request.response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
                completionHandler: { response in
                    let httpCode = response.response?.statusCode ?? 0

                    switch response.result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            if let responseObject = Mapper<E>().map(JSONObject: value), (200...299).contains(httpCode) {
                                completion(responseObject, nil)
                            } else {
                                let responseError = ResponseError(httpCode: httpCode, json: value as! [String: AnyObject])
                                completion(nil, responseError)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showNetworkActivityIndicator(visible: false)

                            let responseError = ResponseError(httpCode: httpCode, error: error)
                            completion(nil, responseError)
                        }
                    }
                })
    }
}

// MARK: - Images with cache

extension HTTPClient {
    func downloadImageOrSetPlaceholder(on imageView: UIImageView,
                                       imageStringURL url: String?,
                                       placeholder: UIImage) {
        if let urlAsString = url, !urlAsString.isEmpty {
        
            ImageManager
                    .shared
                    .setImageOrPlaceholder(onImageView: imageView, stringURL: urlAsString, placeholder: placeholder)
        } else {
            imageView.image = placeholder
        }
    }

    func downloadImageOrSetPlaceholder(on imageView: UIImageView,
                                       imageStringURL url: String?) {
        if let urlAsString = url {

            ImageManager
                    .shared
                    .setImageOrPlaceholder(onImageView: imageView, stringURL: urlAsString)
        }
    }

    func downloadImageOrSetPlaceholder(on imageView: UIImageView,
                                       imageStringURL url: String?,
                                       placeholder: UIImage? = nil) {
        if let urlAsString = url {
            ImageManager
                    .shared
                    .setImageOrPlaceholder(onImageView: imageView, stringURL: urlAsString)
        } else {
            imageView.image = placeholder ?? Asset.defaultImage
        }
    }

    func downloadImage(imageStringURL url: String?,
                       completion: @escaping (_ image: UIImage?, _ error: ImageError?) -> Void) {
        ImageManager
                .shared
                .getImage(stringURL: url, completion: completion)
    }

    func setupImageManager() {
        ImageManager.shared.maximumActiveDownloads = maximumImagesActiveDownloads
        ImageManager.shared.memoryImagesCapacityInMegaBytes = memoryImagesCapacityInMegaBytes
        ImageManager.shared.memoryUsageAfterPurgeInMegaBytes = memoryImagesUsageAfterPurgeInMegaBytes
    }
}
