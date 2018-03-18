//
//  RecipeListServices.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class RecipeListService {
    
    // MARK: - Private properties
    
    private var httpClient: HTTPClient = HTTPClient.shared

    // MARK: - Initialization
    
    init() {
        
    }
    
    func getRecipesResponse(withQuery query: String, completion: @escaping (RecipesResponseEntity?, ResponseError?) -> Void) {
        let params: [String: Any] = ["query": query, "limit": 500]
        httpClient.responseObject(router: RecipeListRouter.list(params), completion: completion)
    }
    
}
