//
//  RecipeDetailService.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class RecipeDetailsService {
    
    // MARK: - Private properties
    
    private var httpClient: HTTPClient = HTTPClient.shared
    
    // MARK: - Initialization
    
    init() {
        
    }
    
    func getRecipeDetails(withId id: Int, completion: @escaping (RecipeDetailsEntity?, ResponseError?) -> Void) {
        httpClient.responseObject(router: RecipeDetailsRouter.details(id: id), completion: completion)
    }
    
}
