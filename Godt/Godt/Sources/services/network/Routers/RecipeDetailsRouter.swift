//
//  RecipeDetailsRouter.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import Alamofire

enum RecipeDetailsRouter: URLRequestConvertible {
    case details(id: String)
    
    var method: HTTPMethod {
        switch self {
        case .details:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .details(let id):
            return "recipes/\(id)"
        }
    }
    
    var params: (Parameters?) {
        switch self {
        case .details(_):
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .details(_):
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

