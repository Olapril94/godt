//
//  RecipeListViewModel.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeListViewModel {
    
    // MARK: - Private properties
    
    private let service: RecipeListService!
    private weak var controller: RecipeListViewControllerDelegate?
    
    // MARK: - Intialization
    
    init(controller: RecipeListViewControllerDelegate) {
        service = RecipeListService()
        self.controller = controller
    }
    
    func getRecipeResponse(withQuery query: String, completion: @escaping (RecipesResponseDomain) -> Void) {
        
        service.getRecipesResponse(withQuery: query) { (recipesResponse, error) in
            if let recipesResponseEntity = recipesResponse {
                completion(RecipesResponseDomain(entity: recipesResponseEntity))
            }
            
            if let error = error {
                self.controller?.showError(withMessage: error.localizedMessage)
            }
        }
    }
}
