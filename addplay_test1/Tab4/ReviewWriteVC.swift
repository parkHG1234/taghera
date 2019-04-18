//
//  ReviewWriteVC.swift
//  addplay_test1
//
//  Created by 08liter on 17/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReviewWriteVC: UIViewController {

    var Pk = ""
    var Image = ""
    var selectFocusList = [User_MyActivity_Select_Focus]()
    var userPk = ""
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instargramTextField: UITextField!
    @IBOutlet weak var naverblogTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        userPk = self.preferences.string(forKey: "user_pk")!
        initListData()
    }
    
    func initListData(){
        var arrRes = [[String:AnyObject]]()
        let param = [
            "Data1":Pk
        ]
        Alamofire.request("http://13.209.148.229/Web_Taghera/User_MyActivity_Select_Focus.jsp",method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON{(responseData) -> Void in
            print(responseData)
            if(responseData.result.value != nil){
                self.selectFocusList.removeAll()
                let Data = JSON(responseData.result.value!)
                if let resData = Data["List"].arrayObject{
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                if arrRes.count > 0{
                    for i in 0...arrRes.count-1{
                        var dict = arrRes[i]
                        self.selectFocusList.append(User_MyActivity_Select_Focus(
                            Category_Pk: dict["msg1"] as! String,
                            Goods_Pk: dict["msg2"] as! String,
                            Goods_Title: dict["msg9"] as! String,
                            Goods_Kind: dict["msg10"] as! String,
                            HashTag: dict["msg11"] as! String))
                    }
                    self.layoutInit()
                }
            }else{
                
            }
        }
    
    }
    func layoutInit(){
        profileImage.af_setImage(withURL: URL(string:Image)!)
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        itemLabel.text = self.selectFocusList[0].Goods_Title
        keyboardHide(textField: facebookTextField)
        keyboardHide(textField: instargramTextField)
        keyboardHide(textField: naverblogTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    

    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func sendButton(_ sender: Any) {
        var arrRes = [[String:AnyObject]]()
        let param = [
            "Data1": userPk,
            "Data2": selectFocusList[0].Goods_Pk,
            "Data3": self.facebookTextField.text!,
            "Data4": self.instargramTextField.text!,
            "Data5": self.naverblogTextField.text!,
            "Data6": selectFocusList[0].Goods_Kind
        ]
        
        Alamofire.request("http://13.209.148.229/Web_Taghera/MyActivity_Review_Input.jsp",method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseString{(responseData) -> Void in if(responseData != nil){
            
            let result = responseData.result.value! as String
            
            if result.contains("succed"){
                let storyBoard = self.storyboard!
                let Like = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                Like.selectedIndex = 3
                self.present(Like, animated: true, completion: nil)
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시시도해주세요")
            }
            }
        }
    }
    
}
