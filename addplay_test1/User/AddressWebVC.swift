//
//  AddressWebVC.swift
//  addplay_test1
//
//  Created by 08liter on 12/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//


import UIKit
import WebKit
import CoreLocation

protocol AddressWebVCDelegate {
    func address(str: String)
}


class AddressWebVC: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var WebView: UIWebView!
    
    var AddressWebVCDelegate : AddressWebVCDelegate!
    
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
                self.keyboardHide(textField: firstTextField)
                if firstTextField.text == nil{
                    self.present(self.commonAlert(message: "다시 입력해주세요"), animated: true, completion: nil)
                }else if firstTextField.text == ""{
                    self.present(self.commonAlert(message: "다시 입력해주세요"), animated: true, completion: nil)
                }else{
                    self.convertToAddressWith(address: postCodeData["addr"] as! String, address_focus: firstTextField.text!)
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


extension AddressWebVC: CLLocationManagerDelegate{
    func convertToAddressWith(address: String, address_focus: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            print(address)
            print(address_focus)
            self.AddressWebVCDelegate.address(str: address)
            self.navigationController?.popViewController(animated: true)
//            if placemarks!.count > 0 {
//                let placemark = placemarks?[0]
//                let location = placemark?.location
//                let coordinates = location?.coordinate
//
////                let x = Double((coordinates?.latitude)!)
////                let y = Double((coordinates?.longitude)!)
//
//
//            }
        })
}
}
