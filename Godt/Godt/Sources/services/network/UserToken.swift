//
//  UserToken.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class UserToken {
    var accessCookieToken: HTTPCookie!
    var refreshToken: String!
    var user: String
    
    init(accessCookieToken: HTTPCookie, refreshToken: String, user: String) {
        self.accessCookieToken = accessCookieToken
        self.refreshToken = refreshToken
        self.user = user
    }
}
