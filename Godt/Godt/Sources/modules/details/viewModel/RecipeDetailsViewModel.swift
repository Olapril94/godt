//
//  RecipeDetailsViewModel.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailsViewModel {
    
    // MARK: - Private properties
    
    private let service: RecipeDetailsService!
    private weak var controller: RecipeDetailsViewControllerDelegate?
    var recipeSection: RecipeSection = .description
    
    let headerCellHeight: CGFloat = 40
    
    var sections: [RecipeSection] = [.description, .info]
    
    // MARK: - Intialization
    
    init(controller: RecipeDetailsViewControllerDelegate) {
        service = RecipeDetailsService()
        self.controller = controller
    }
    
    // MARK: - Recipe details
    
    func getRecipeDetails(withId id: Int, completion: @escaping (RecipeDetailsDomain) -> Void) {
        service.getRecipeDetails(withId: id) { (recipeDetails, error) in
            if let recipeDetailsEntity = recipeDetails {
                completion(RecipeDetailsDomain(entity: recipeDetailsEntity))
            }
            
            if let error = error {
                self.controller?.showError(withMessage: error.localizedMessage)
            }
        }
    }
    
    // MARK: Sections
    
}
