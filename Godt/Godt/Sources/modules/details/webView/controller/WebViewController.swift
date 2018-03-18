//
//  WebViewController.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 18/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Private properties
    
    private var viewModel: WebViewModel?
    
    // MARK: - Public properties
    
    var id: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WebViewModel(controller: self)
        
        if let id = id {
            viewModel?.setupWebView(with: id) { request in
                self.webView.load(request)
            }
        }
    }
}


// MARK: - Recipe details view controller delegate

extension WebViewController: WebViewControllerDelegate {
    func showError(withMessage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.show(self, sender: nil)
    }
}



