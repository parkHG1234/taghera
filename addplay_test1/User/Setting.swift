//
//  Setting.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 8..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class Setting: UIViewController {
    let preferences = UserDefaults.standard
    var Array = [user_item]()
    var user_pk = ""
    @IBOutlet weak var ui_txt_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        user_pk = self.preferences.string(forKey: "user_pk")!
        print(user_pk)
        http()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    @IBAction func ui_btn_drop(_ sender: Any) {
        Alamofire.request("http://13.209.148.229/Web_Taghera/User_Drop.jsp?Data1="+user_pk)
        self.preferences.set("", forKey: "user_pk")
        self.performSegue(withIdentifier: "segLogout", sender: self)
    }
    @IBAction func ui_btn_logout(_ sender: Any) {
        self.preferences.set("", forKey: "user_pk")
        self.performSegue(withIdentifier: "segLogout", sender: self)
    }
    func http() {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/User.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            
            let Data = JSON(responseData.result.value!)
            
            if let resData = Data["List"].arrayObject {
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    
                    self.Array.append(user_item(phone: dict["msg4"] as! String))
                }
                self.ui_txt_name.text = self.Array[0].phone+"님"
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
}
class user_item{
    let phone : String
    
    init(phone: String) {
        self.phone = phone

    }
}

