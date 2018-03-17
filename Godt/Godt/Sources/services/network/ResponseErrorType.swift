//
//  ResponseErrorType.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

enum ResponseErrorType: Int {
    case unknown
    case noNetworkConnection
    case serverUnavailable
    case clientStatusError
    case serverStatusError
    case serverResponseError
}
