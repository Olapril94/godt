//
//  WebViewModel.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 18/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation
import UIKit

class WebViewModel {
    
    // MARK: - Private properties
    
    private weak var controller: WebViewControllerDelegate?
    
    // MARK: - Intialization
    
    init(controller: WebViewControllerDelegate) {
        self.controller = controller
    }
    
    // MARK: - WebView request
    
    func setupWebView(with id: Int, completion: @escaping (URLRequest) -> Void) {
        let url = URL(string: "https://www.godt.no/oppskrift/\(id)")
        if let url = url {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { ( data, response, error) in
                if error != nil {
                    self.controller?.showError(withMessage: "WebView initialization failed")
                }
                completion(request)
            }
            
            task.resume()
        }
    }
}
