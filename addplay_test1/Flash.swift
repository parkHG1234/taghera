//
//  Flash.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 2..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Flash: UIViewController {
    let AppVersion = "1.0"
    var version_url = "http://13.209.148.229/Web_Taghera/Setting.jsp"
    var count = 0
    var arrRes = [[String:AnyObject]]()
    var user_pk = ""
    let preferences = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        if preferences.object(forKey: "user_pk") != nil {
            user_pk = self.preferences.string(forKey: "user_pk")!
        }
        
        
        VersionCheck()
        app_data()
    }
    
    func app_data(){
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        Alamofire.request("http://13.209.148.229/Web_Taghera/Setting_Toady_Counting.jsp?Data1="+dateFormat.string(from: today as Date))
    }
    
    func VersionCheck(){
        Alamofire.request(version_url).responseJSON{(responseData) -> Void in
            if(responseData.result.value != nil){
                let Data = JSON(responseData.result.value!)
                
                if let resData = Data["List"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0...self.arrRes.count-1{
                        var dict = self.arrRes[i]
                        let WebVersion = dict["msg2"] as! String
                        
                        print(WebVersion)
                        print(self.AppVersion)
                        
                        if (WebVersion == self.AppVersion){
                            self.TimeCheck()
                        }else {
                            let alertController = UIAlertController(title: nil,
                                                                    message: "어플리케이션 업데이트",
                                                                    preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title:"업데이트", style:.default, handler:{(action: UIAlertAction!) in self.applestore()}))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func TimeCheck(){
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        count += 1
        if(count == 3){
            if user_pk == "" {
                performSegue(withIdentifier: "segLogin", sender: self)
            }
            else{
                performSegue(withIdentifier: "segMain", sender: self)
            }
            
        }
    }
    
    func applestore(){
        let appStoreLink = "https://itunes.apple.com/us/app/apple-store/id1343687835"
        
        /* First create a URL, then check whether there is an installed app that can
         open it on the device. */
        if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
            // Attempt to open the URL.
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                    if success {
                        print("Launching \(url) was successful")
                    }})
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
