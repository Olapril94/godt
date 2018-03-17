//
// Created by Aleksandra Kwiecien on 17/03/2018.
// Copyright (c) 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import ObjectMapper

class RecipesResponseEntity: Mappable {
    var count: Int?
    var results: [RecipeEntity]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.count <- map["count"]
        self.results <- map["results"]
    }
}
