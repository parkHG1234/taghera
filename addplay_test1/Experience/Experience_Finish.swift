//
//  Experience_Finish.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 4..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import WebKit
class Experience_Finish: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = nil
    }
    
    @IBAction func img_back(_ sender: Any) {
       
       
        let storyBoard = self.storyboard!
        let Like = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(Like, animated: true, completion: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}



