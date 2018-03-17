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
    
    // MARK: - Intialization
    
    init() {
        service = RecipeListService()
    }
}
