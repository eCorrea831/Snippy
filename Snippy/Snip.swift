//
//  Snips.swift
//  Snippy
//
//  Created by Aditya Narayan on 6/16/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

import UIKit

class Snip {

    var title:String
    var url:String
    var id:String = ""
    
    init(title:String, url:String) {
        self.title = title
        self.url = url
    }
}
