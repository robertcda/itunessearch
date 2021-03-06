//
//  String+Extensions.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
extension String{
    var replaceSpaceWithAPlus: String{
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
    var nonEmptyString: String? {
        if self.count >= 1{
            return self
        }else {
            return nil
        }
    }
}
