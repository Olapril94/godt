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
    
    // MARK: - Public properties
    
    private var viewModel: RecipeListViewModel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RecipeListViewModel()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setupNavigationBar()
        setupSerchBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        
    }
    
    private func setupSerchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Search bar delegate

extension RecipeListViewController: UISearchBarDelegate {
    
}

// MARK: - Table view delegate + data source

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
