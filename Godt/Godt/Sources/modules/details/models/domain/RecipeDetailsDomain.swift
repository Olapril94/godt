//
//  RecipeDetailsDomain.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class RecipeDetailsDomain {
    let title: String
    let description: String
    let numberOfLikes: Int
    let imageUrl: String
    
    init(entity: RecipeDetailsEntity, imageUrl: String) {
        title = entity.title ?? ""
        description = entity.description ?? ""
        numberOfLikes = entity.numberOfLikes ?? 0
        self.imageUrl = imageUrl
    }
}
