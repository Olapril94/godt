//
//  UserAuthManager.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class UserAuthManager {
    static let shared = UserAuthManager()
    
    var kUserAccessCookieTokenKey: String {
        return "user_access_token"
    }
    
    var kUserKey: String {
        return "user_refresh_token"
    }
    
    var userJustRegistered: Bool = false
    
    private init() {
        
    }
    
    func saveUser(user: String) {
        debugPrint("accessToken: \(user)")
        UserDefaults().setValue(user, forKey: kUserKey)
    }
    
    func logout() {
        remove()
    }
    
    private func remove() {
        UserDefaults().setValue(nil, forKey: kUserAccessCookieTokenKey)
        UserDefaults().setValue(nil, forKey: kUserKey)
    }
    
    func setCookie(cookie: HTTPCookie) {
        UserDefaults.standard.set(cookie.properties, forKey: kUserAccessCookieTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: kUserAccessCookieTokenKey) as? [[HTTPCookiePropertyKey: Any]] else { return }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
    func isLogged() -> Bool {
        if UserDefaults().string(forKey: kUserAccessCookieTokenKey) != nil {
            return true
        }
        return false
    }
    
    func username() -> String? {
        let temp = UserDefaults().string(forKey: kUserKey)
        return temp
    }
}
