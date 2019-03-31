//
//  Setting.swift
//  addplay_test1
//
//  Created by MC976-002 on 31/03/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Tab4_Setting: UIViewController {
    @IBOutlet weak var txt_name: UILabel!
    var user_pk:String = "434"
    let preferences = UserDefaults.standard
    var Array_user = [item_tab4_user]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //user_pk = self.preferences.string(forKey: "user_pk")!
        
        http_user()
    }
    
    func http_user() {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/User.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.txt_name.text = dict["msg3"] as! String
                }
            }
        }
    }
}

