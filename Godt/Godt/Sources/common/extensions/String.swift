//
//  String.swift
//  Godt
//
//  Created by Aleksandra Kwiecien on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

extension String {
    
    var asNSString: NSString { return self as NSString }
    
    // MARK: - Localized
    
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
