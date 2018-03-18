//
//  RecipeTableViewCell.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    func setup(data: RecipeDomain) {
        titleLabel.text = data.title
        recipeImageView.set(imageByStringURL: data.imageUrl)
    }
}
