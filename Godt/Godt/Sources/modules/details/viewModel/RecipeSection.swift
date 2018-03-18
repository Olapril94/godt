//
//  RecipeSection.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 18/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

enum RecipeSection: Int {
    case description = 0
    case info = 1
    
    var recipeSectionTitle: String {
        switch self {
        case .description:
            return "Recipe.description".localized
        case .info:
            return "Recipe.info".localized
        }
    }
    
    var recipeSectionCellHeight: CGFloat {
        switch self {
        case .description:
            return 150
        case .info:
            return 40
        }
    }
}

