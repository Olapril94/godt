//
//  ImageError.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

struct ImageError {
    var message: String?
    var httpCode: Int?
    var requestURL: URLRequest?
    var alamofireCode: Int?

    init(message: String) {
        self.message = message
    }

    init(message: String?, alamofireCode: Int?, httpCode: Int?, requestURL: URLRequest?) {
        self.message = message
        self.alamofireCode = alamofireCode
        self.httpCode = httpCode
        self.requestURL = requestURL
    }

    func toString() -> String {
        return "\(String(describing: message)) | alamofireCode: \(String(describing: alamofireCode)) | HTTP_CODE: \(String(describing: httpCode)) | REQUEST absoluteString: \(String(describing: requestURL?.url?.absoluteString))"
    }
}
