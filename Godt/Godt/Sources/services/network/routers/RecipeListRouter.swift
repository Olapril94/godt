//
//  RecipeListRouter.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import Alamofire

enum RecipeListRouter: URLRequestConvertible {
    case list([String: Any]?)
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list(_):
            return "search/recipes"
        }
    }
    
    var params: (Parameters?) {
        switch self {
        case .list(let params):
            return params
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .list(_):
            return Alamofire.URLEncoding()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Config.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedRequest = try encoding.encode(urlRequest, with: params)
            return encodedRequest
            
        } catch (_) {
            return urlRequest
        }
    }
}

