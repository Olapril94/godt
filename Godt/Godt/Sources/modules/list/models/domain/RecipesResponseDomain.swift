//
//  RecipesResponseDomain.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class RecipesResponseDomain {
    let count: Int
    let results: [RecipeDomain]
    
    init(entity: RecipesResponseEntity) {
        self.count = entity.count ?? 0
        self.results = entity.results?.flatMap { RecipeDomain(entity: $0) } ?? []
    }
}
