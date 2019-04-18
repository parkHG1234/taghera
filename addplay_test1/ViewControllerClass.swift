//
//  ViewControllerClass.swift
//  addplay_test1
//
//  Created by 08liter on 10/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import Foundation
import Alamofire

extension UIViewController{
    
    
    func keyboardHide(textField: UITextField){
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.blue
        
        textField.inputAccessoryView = toolBarKeyboard
    }
    
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }
    
    
    func commonAlert(message: String) -> UIAlertController{
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction( UIAlertAction(title: "확인", style: .default))
        return alertController
    }

    
    class User_MyActivity_List{
        let pk : String
        let image : String
        let status : String
        let goodsPk : String
        
        init(pk: String, image: String, status:String, goodsPk: String){
            self.pk = pk
            self.image = image
            self.status = status
            self.goodsPk = goodsPk
        }
    }
    
    class User_MyActivity_Select_Focus{
        let Category_Pk :String
        let Goods_Pk:String
        let Goods_Title :String
        let Goods_Kind :String
        let HashTag :String
        
        init(Category_Pk: String, Goods_Pk: String, Goods_Title:String, Goods_Kind: String, HashTag: String){
            self.Category_Pk = Category_Pk
            self.Goods_Pk = Goods_Pk
            self.Goods_Title = Goods_Title
            self.Goods_Kind = Goods_Kind
            self.HashTag = HashTag
        }
    }
    
    class User{
        let str_profile :String
        let str_name: String
        let str_phone: String
        let str_email: String
        let grade: String
        let str_point: String
        
        init(str_profile: String, str_name:String, str_phone:String, str_email:String, grade:String, str_point:String){
            self.str_profile = str_profile
            self.str_name = str_name
            self.str_phone = str_phone
            self.str_email = str_email
            self.grade = grade
            self.str_point = str_point
        }
    }
    
    class User_MyActivity_Count{
        let strRequest :String
        let strSelect: String
        let strComplete: String
        
        init(strRequest: String, strSelect:String, strComplete:String){
            self.strRequest = strRequest
            self.strSelect = strSelect
            self.strComplete = strComplete
        }
    }

}
