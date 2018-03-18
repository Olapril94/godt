//
//  RecipeDetailsViewController.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - Private properties
    
    private var viewModel: RecipeDetailsViewModel!
    private var recipeDetails: RecipeDetailsDomain?
    fileprivate let webViewSegueIdentifier = "WebViewSegueIdentifier"
    
    // MARK: - Public properties
    
    var recipeId: Int!
    var imageUrl: String!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RecipeDetailsViewModel(controller: self)
        viewModel.getRecipeDetails(withId: recipeId) { details in
            self.setup(withRecipeDetails: details)
        }
        
        setupView()
        
        tableView.register(UINib(nibName: RecipeHeaderCell.identifier, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: RecipeHeaderCell.identifier)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setupTableView()
        recipeImageView.set(imageByStringURL: imageUrl)
    }
    
    private func setup(withRecipeDetails details: RecipeDetailsDomain) {
        numberOfLikesLabel.text = "\(details.numberOfLikes)"
        self.recipeDetails = details
        
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = viewModel.recipeSection.recipeSectionCellHeight
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewSegueIdentifier {
            if let destinationVC = segue.destination as? WebViewController{
                destinationVC.id = recipeId
            }
        }
    }
}

// MARK: - Table view delegate + data source

extension RecipeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sections[indexPath.section].recipeSectionCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "baseCell"), let data = recipeDetails else {
            return UITableViewCell()
        }
        if viewModel.sections[indexPath.section].rawValue == 0 {
            cell.textLabel?.text = data.description.htmlToString
        } else {
            cell.textLabel?.text = "Recipe.info.decription".localized
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.sections[indexPath.section] == .info {
            performSegue(withIdentifier: webViewSegueIdentifier, sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipeHeaderCell.identifier) as! RecipeHeaderCell
        
        header.setup(title: viewModel.sections[section].recipeSectionTitle)
        return header
    }
    
}

// MARK: - Recipe details view controller delegate

extension RecipeDetailsViewController: RecipeDetailsViewControllerDelegate {
    func showError(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.show(self, sender: nil)
    }
}

