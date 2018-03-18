//
//  RecipeListViewController.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class RecipeListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private var viewModel: RecipeListViewModel!
    fileprivate var recipeResponse: RecipesResponseDomain?
    fileprivate var recipeResponseWithoutSearch: RecipesResponseDomain?
    fileprivate let detailsSegueIdentifier = "RecipeDetailsSegueIdentifier"
    fileprivate let tableViewCellHeight: CGFloat = 70
    
    // MARK: - Public properties
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RecipeListViewModel(controller: self)
        viewModel.getRecipeResponse(withQuery: "") { result in
            self.recipeResponseWithoutSearch = result
            self.recipeResponse = result
            self.tableView.reloadData()
        }
        setupView()
        hideKeyboardOnViewTap()
    }
    
    // MARK: - Request with query
    
    fileprivate func makeRecipesResponseRequest(withQuery query: String = "") {
        viewModel.getRecipeResponse(withQuery: query) { result in
            self.recipeResponse = result
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setupNavigationBar()
        setupSerchBar()
        setupTableView()
        title()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = Color.mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func title() {
        title = "Main.tile".localized
    }
    
    private func setupSerchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewCellHeight
        
        tableView.register(UINib(nibName: String(describing: RecipeTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: RecipeTableViewCell.self))
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeDetailsViewController, let recipe = sender as? RecipeDomain {
            destinationViewController.recipeId = recipe.id
            destinationViewController.imageUrl = recipe.imageUrl
        }
    }
}

// MARK: - Search bar delegate

extension RecipeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            makeRecipesResponseRequest(withQuery: searchText)
        }
        
        if searchText.count == 2 {
            recipeResponse = recipeResponseWithoutSearch
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recipeResponse = recipeResponseWithoutSearch
        tableView.reloadData()
    }
}

// MARK: - Table view delegate + data source

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeResponse?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeTableViewCell.self), for: indexPath) as? RecipeTableViewCell, let data = recipeResponse?.results[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setup(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = recipeResponse?.results[indexPath.row]
        performSegue(withIdentifier: detailsSegueIdentifier, sender: id)
    }
}

// MARK: - Recipe list controller delegate

extension RecipeListViewController: RecipeListViewControllerDelegate {
    func showError(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.show(self, sender: nil)
    }
}

// MARK: - Keyboard dismiss tap handling

extension RecipeListViewController {
    func hideKeyboardOnViewTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
