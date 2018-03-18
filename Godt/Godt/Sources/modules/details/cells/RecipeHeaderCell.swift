//
//  RecipeHeaderCell.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeHeaderCell: UITableViewHeaderFooterView {
   
    // MARK: - Properties
    
    static var identifier: String = "RecipeHeaderCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Cell initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.white
    }
    
    // MARK: - Setup
    
    func setup(title: String) {
        titleLabel.text = title
    }
}
