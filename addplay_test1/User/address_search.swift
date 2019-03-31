//
//  address_search.swift
//  addplay_test1
//
//  Created by MC976-002 on 21/03/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import Foundation
import WebKit
import CoreLocation

protocol AddressData {
    func Address(str :String)
    func Address_focus(str :String)
    func Address_x(str :String)
    func Address_y(str :String)
}

class address_search: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var WebView: UIWebView!
    
    var AddressData : AddressData!
    
    var address_url = "https://www.trilliwon.com/postcode/"
    var test_url = "https://m.naver.com"
    var webView = WKWebView()
    var activityIndicator = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        
        let controller = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(userScript)
        
        controller.add(self, name: "callBackHandler")
        
        config.userContentController = controller
        
        
        webView = WKWebView(frame: self.containerView.frame, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: address_url)
        let request = URLRequest(url: url!)
        webView.load(request)
        //        WebView.loadRequest(request)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        
        if let postCodeData = message.body as? [String: Any]{
            
            let alertController = UIAlertController(title: nil, message: "상세주소를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "상세주소를 입력해주세요"
            }
            let saveAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                //self.keyboardHide(textField: firstTextField)
                if firstTextField.text == nil{
                    Toast.shared.long(self.view, msg: "다시 입력해주세요")
                }else if firstTextField.text == ""{
                    Toast.shared.long(self.view, msg: "다시 입력해주세요")
                }else{
                    //self.convertToAddressWith(address: postCodeData["addr"] as! String, address_focus: firstTextField.text!)
                }
            })
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
}

