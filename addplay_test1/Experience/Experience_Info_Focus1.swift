//
//  Experience_Info_Focus1.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 17..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import WebKit
class Experience_Info_Focus1: UIViewController{
    var Title:String = ""
    var Content:String = ""
    
    @IBOutlet weak var ui_title: UILabel!
    @IBOutlet weak var ui_content: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_title.text = Title
        ui_content.text = Content
    }
    
}

