//
//  RecipeDomain.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class RecipeDomain {
    let title: String
    let id: Int
    let imageUrl: String
    
    init(entity: RecipeEntity) {
        self.title = entity.title ?? ""
        self.id = entity.id ?? -1
        self.imageUrl = entity.imageUrl ?? ""
    }
}
