//
//  RecipeDetailsEntity.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import ObjectMapper

class RecipeDetailsEntity: Mappable {
    var title: String?
    var description: String?
    var numberOfLikes: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.description <- map["description"]
        self.numberOfLikes <- map["numberOfLikes"]
    }
}
