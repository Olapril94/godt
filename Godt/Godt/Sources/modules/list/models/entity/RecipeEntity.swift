//
//  RecipeEntity.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import ObjectMapper

class RecipeEntity: Mappable {
    var title: String?
    var id: Int?
    var imageUrl: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.id <- map["id"]
        self.imageUrl <- map["image"]
    }
}
