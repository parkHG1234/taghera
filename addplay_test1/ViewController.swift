//
//  ViewController.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 4. 13..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

class ViewController: UIViewController , UITextFieldDelegate{
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var ui_txt_phone: UITextField!
    @IBOutlet weak var ui_txt_pass: UITextField!
    var Array = [item1]()
    var phone:String?
    var pass:String?
    
    @IBAction func act_btn_join(_ sender: Any) {
        self.performSegue(withIdentifier: "segJoin", sender: self)
    }
    @IBAction func act_btn_login(_ sender: Any) {
        http()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ui_txt_phone.delegate = self
        ui_txt_pass.delegate = self
        
        self.ui_txt_phone.keyboardType = UIKeyboardType.numberPad
        
        //밑줄 넣기
        ui_txt_phone.addBorderBottom(height: 1.0, color: UIColor.white)
        ui_txt_pass.addBorderBottom(height: 1.0, color: UIColor.white)
        
        ui_txt_pass.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func http(){
        print(ui_txt_phone.text)
        print(ui_txt_pass.text)
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Login.jsp?Data1="+ui_txt_phone.text!+"&Data2="+ui_txt_pass.text!).responseJSON{(responseData) -> Void in
            var Data = JSON(responseData.result.value!)
            if var resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array = [item1(pk: dict["msg1"] as! String)]
                }
                //로그인 검사
                print(self.Array[0].pk)
                if(self.Array[0].pk == "failed"){
                    Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
                }
                else{
                    self.preferences.set(self.Array[0].pk, forKey: "user_pk")
                    self.performSegue(withIdentifier: "segMain", sender: self)
                }
            }else{
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -150 // Move view 150 points upward
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
}
class item1{
    let pk : String
    init(pk: String) {
        self.pk = pk
    }
}

