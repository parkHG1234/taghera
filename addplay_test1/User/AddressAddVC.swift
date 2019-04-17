//
//  AddressAddVC.swift
//  addplay_test1
//
//  Created by 08liter on 12/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import UIKit
import Alamofire


protocol addressAddDelegate {
    func addressAdd(address:String)
}

class AddressAddVC: UIViewController {

    @IBOutlet weak var deliver_title: UITextField!
    @IBOutlet weak var deliver_name: UITextField!
    @IBOutlet weak var deliver_code: UILabel!
    @IBOutlet weak var delivier_address: UILabel!
    @IBOutlet weak var deliver_address_detail: UITextField!
    @IBOutlet weak var deliver_phone: UITextField!
    @IBOutlet weak var deliver_memo: UITextField!
    
    var addressAddDelegate : addressAddDelegate!
    var user_pk = UserDefaults.standard.string(forKey: "user_pk")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardHide(textField: deliver_title)
        keyboardHide(textField: deliver_name)
        keyboardHide(textField: deliver_address_detail)
        keyboardHide(textField: deliver_phone)
        keyboardHide(textField: deliver_memo)
    }
    

    @IBAction func addressWeb(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddressWebVC") as? AddressWebVC
        vc?.AddressWebVCDelegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addAddress(_ sender: Any) {
        if(deliver_title.text == ""){
            Toast.shared.long(self.view, msg: "배송지명을 입력해주세요")
            return
        }
        if(deliver_name.text == ""){
            Toast.shared.long(self.view, msg: "받는사람을 입력해주세요")
            return
        }
        if(deliver_code.text == ""){
            Toast.shared.long(self.view, msg: "우편코드를 입력해주세요")
            return
        }
        if(delivier_address.text == ""){
            Toast.shared.long(self.view, msg: "우편주소를 입력해주세요")
            return
        }
        if(deliver_address_detail.text == ""){
            Toast.shared.long(self.view, msg: "상세주소를 입력해주세요")
            return
        }
        if(deliver_phone.text == ""){
            Toast.shared.long(self.view, msg: "핸드폰번호를 입력해주세요")
            return
        }
        if(deliver_memo.text == ""){
            Toast.shared.long(self.view, msg: "메모를 입력해주세요")
            return
        }
        
        let param = [
            "Data1" : self.user_pk,
            "Data2" : self.deliver_title.text!,
            "Data3" : self.deliver_code.text!,
            "Data4" : self.delivier_address.text!,
            "Data5" : self.deliver_address_detail.text!,
            "Data6" : self.deliver_phone.text!,
            "Data7" : self.deliver_memo.text!
        ]
        
        Alamofire.request("http://13.209.148.229/Web_Taghera/Address_Add.jsp", method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseString{(responseString2) -> Void in
            if((responseString2.result.value?.contains("succed"))!){
                self.addressAddDelegate.addressAdd(address: self.deliver_title.text!)
                self.navigationController?.popViewController(animated: true)
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
}


extension AddressAddVC: AddressWebVCDelegate{
    func address_code(str:String ){
        self.deliver_code.text = str
    }
    func address(str: String) {
        self.delivier_address.text = str
    }
}
