//
//  TermFocus.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 3..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol MyProtocol {
    func setViewedUrl(viewUrl: String)
}
class TermFocus: UIViewController, WKNavigationDelegate{
    var callback : ((String) -> Void)?
    var myProtocol: MyProtocol?
    @IBOutlet weak var ui_web_term: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url:URL = URL(string: "http://13.124.32.32:8080/Blah_Doc/privacy.php")!
        let urlRequest:URLRequest = URLRequest(url: url);
        ui_web_term.load(urlRequest)
        ui_web_term.navigationDelegate = self
    }

    @IBAction func ui_btn_Agree(_ sender: Any) {
        myProtocol?.setViewedUrl(viewUrl: "true")
        navigationController?.popViewController(animated: true)
    }
}




