//
//  ApiKeys.swift
//  Stormy
//
//  Created by Ryan Walker on 5/17/15.
//  Copyright (c) 2015 Witt Labs, LLC. All rights reserved.
//

import Foundation

func valueForAPIKey(#keyname: String) -> String {
    let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    
    let value: String = plist!.objectForKey(keyname) as! String
    
    return value
}