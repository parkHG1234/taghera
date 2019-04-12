//
//  JoinView.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 4. 19..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class JoinView: UIViewController, MyProtocol{
    let preferences = UserDefaults.standard
    
    var Array = [item]()
    var Array_code = [item_code]()
    var Array_user = [item_user]()
    var code_overlap = true
    var code_checked = ""
    
    var countdownTimer: Timer!
    var totalTime = 180
    var str_phone = ""
    var str_pass = ""
    var rnd = 0
    
    var term_flag = ""
    var valueSentFromSecondViewController:String?
    
    
    @IBOutlet weak var ui_btn_resms: UIButton!
    @IBOutlet weak var ui_btn_join: UIButton!
    @IBOutlet weak var ui_btn_term: UIButton!
    @IBOutlet weak var ui_btn_sms: UIButton!
    @IBOutlet weak var ui_edit_certi: UITextField!
    @IBOutlet weak var ui_edit_pass: UITextField!
    @IBOutlet weak var ui_edit_passcheck: UITextField!
    @IBOutlet weak var ui_txt_phone: UITextField!
    @IBOutlet weak var ui_txt_certi: UILabel!
    @IBOutlet weak var ui_img_term: UIImageView!
    @IBOutlet weak var ui_layout_certi: UIStackView!
    @IBOutlet weak var ui_layout_pass: UIStackView!
    @IBOutlet weak var ui_layout_passcheck: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtnsms()
        setTxtPhone()
        setTxtCerti()
        setlayoutCerti()
        setTextPasscheck()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //ui_btn_join.layer.backgroundColor = UIColor.gray.cgColor
        //ui_btn_join.isEnabled = false
//        http_code()
       
    }
    func setlayoutCerti(){
        ui_layout_certi.isHidden = true
        
        keyboardHide(textField: ui_edit_certi)
        keyboardHide(textField: ui_edit_pass)
        keyboardHide(textField: ui_edit_passcheck)
        keyboardHide(textField: ui_txt_phone)
    }
    @IBAction func ui_btn_join(_ sender: Any) {
        http_join()
    }
    
    func setBtnsms(){
        ui_btn_sms.isEnabled = false
        ui_btn_sms.layer.borderColor = UIColor.gray.cgColor
        ui_btn_sms.layer.borderWidth = 1.0
    }
    
    func setTxtPhone(){
        ui_txt_phone.tag = 0
        self.ui_txt_phone.keyboardType = UIKeyboardType.numberPad
        ui_txt_phone.addTarget(self, action: #selector(JoinView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    func setTxtCerti(){
        ui_edit_certi.tag = 1
        self.ui_edit_certi.keyboardType = UIKeyboardType.numberPad
        ui_edit_certi.addTarget(self, action: #selector(JoinView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    func setTextPasscheck() {
        ui_edit_passcheck.tag = 3
        ui_edit_passcheck.addTarget(self, action: #selector(JoinView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }

    @IBAction func ui_btn_certi(_ sender: Any) {
        http_phoneConfirm(phone: str_phone)
    }
    @IBAction func ui_btn_resms(_ sender: Any) {
        endTimer();
        totalTime = 180
        ui_layout_certi.isHidden = true
        ui_btn_sms.isHidden = false
        self.ui_txt_phone.isEnabled = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segTerm"){
            if let TermFocus = segue.destination as? TermFocus {
                TermFocus.myProtocol = self
            }
        }
        else if (segue.identifier == "segDone"){
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField){
        //핸드폰 텍스트 체인지 이벤트
        if textField.tag == 0 {
            str_phone = ui_txt_phone.text!
            if(ui_txt_phone.text?.characters.count == 0){
                ui_btn_sms.layer.backgroundColor = UIColor.gray.cgColor
                ui_btn_sms.layer.borderColor = UIColor.gray.cgColor
                ui_btn_sms.layer.borderWidth = 1.0
                ui_btn_sms.isEnabled = false
            }
            else{
                ui_btn_sms.layer.backgroundColor = appColor.cgColor
                ui_btn_sms.isEnabled = true
            }
        }
        
        //문자 텍스트 체인지 이벤트
        else if textField.tag == 1 {
            if ui_edit_certi.text?.characters.count == 6 {
                if ui_edit_certi.text == String(rnd) {
                    endTimer();
                    ui_edit_certi.isEnabled = false
                    ui_txt_certi.isHidden = true
                    ui_btn_resms.isHidden = true
                    ui_layout_pass.isHidden = false
                    ui_layout_passcheck.isHidden = false
                }
            }
        }
        
        else if textField.tag == 3 {
            if ui_edit_pass.text == ui_edit_passcheck.text {
                str_pass = ui_edit_pass.text!
                ui_btn_term.isHidden = false
                ui_img_term.isHidden = false
            }
            else {
                ui_btn_term.isHidden = true
                ui_img_term.isHidden = true
            }
        }
    }
    
    func http_phoneConfirm(phone:String) -> Void {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Phone_Confirm.jsp?Data1="+phone).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array.append(item(pk: dict["msg1"] as! String))
                }
                
                print(self.Array[0].pk)
                //신규 회원인 경우 문자 인증 전송
                if self.Array[0].pk.contains("not existent") {
                    self.http_phoneSms(phone: phone)
                    self.startTimer();
                    self.ui_layout_certi.isHidden = false
                    self.ui_btn_sms.isHidden = true
                    self.ui_txt_phone.isEnabled = false
                }
                //기존 가입 고객인 경우
                else{
                    Toast.shared.long(self.view, msg: "이미 등록된 번호입니다")
                }
            }else{
                
            }
        }
    }
    
    class item{
        let pk : String
        init(pk: String) {
            self.pk = pk
        }
    }
    
    func http_phoneSms(phone:String) {
        rnd = Int(arc4random_uniform(UInt32(899999)) + UInt32(100000))//난수 생성
        print(String(rnd))
        let now = NSDate() // 현재 날짜 및 시간 체크
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale! // 로케일 설정
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 날짜 형식 설정
        
        let date = dateFormatter.string(from: now as Date)
        print(date) // -> 2014/08/25 08:13:18
        
        let parameters = [
            "Data1": "태그해라 인증번호는 ["+String(rnd)+"] 입니다. 감사합니다.",
            "Data2": phone,
            "Data3": "15662649",
            "Data4": date
        ]
        Alamofire.request("http://13.209.148.229/InetSMSExample/example.jsp", method: .post, parameters: parameters)
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        ui_txt_certi.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func setViewedUrl(viewUrl: String)
    {
        term_flag = viewUrl
        if term_flag == "true"
        {
            ui_btn_term.layer.borderColor = appColor.cgColor
            ui_btn_term.layer.borderWidth = 1.0
            ui_img_term.image = UIImage(named: "check.png")
            ui_btn_join.layer.backgroundColor = appColor.cgColor
            ui_btn_join.isEnabled = true
        }
        else
        {
            ui_btn_term.layer.borderColor = UIColor.gray.cgColor
            ui_btn_term.layer.borderWidth = 1.0
            ui_img_term.image = UIImage(named: "non_check.png")
            ui_btn_join.layer.backgroundColor = UIColor.gray.cgColor
            ui_btn_join.isEnabled = false
        }
    }
    func http_code(){
        var code = randomString(length: 4)
        print(code)
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Recommend_CodeCheck.jsp?Data1="+code).responseString{(responseData) -> Void in
            print(responseData)
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            print(responseData.result.value!)
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array_code.append(item_code(msg1: dict["msg1"] as! String))
                }
                //로그인 검사
                print(self.Array_code[0].msg1)
                if(self.Array_code[0].msg1 == "exist"){
                    self.http_code()
                }
                else{
                    self.code_checked = code
                }
            }else{
                
            }
            
        }
    }
    func http_join(){
        var arrRes1 = [[String:AnyObject]]()
        let parameters = [
            "Data1": ui_txt_phone.text!,
            "Data2": ui_edit_pass.text!,
            "Data3": "agree",
            "Data4": "agree",
            "Data5": "agree",
            "Data6": "agree",
            "Data7": code_checked,
        ]
        Alamofire.request("http://13.209.148.229/Web_Blah/Join_Basic.jsp", method: .post, parameters: parameters).responseJSON{(responseData) -> Void in
            print("aaaaaaa")
            print(responseData)
            let Data1 = JSON(responseData.result.value!)
            if let resData1 = Data1["List"].arrayObject{
                arrRes1 = resData1 as! [[String:AnyObject]]
            }
             print(responseData.result.value!)
            if arrRes1.count > 0{
                for i in 0...arrRes1.count-1{
                    var dict = arrRes1[i]
                    self.Array_user.append(item_user(pk: dict["msg1"] as! String))
                }
                print(self.Array_user[0].pk)
                self.preferences.set(self.Array_user[0].pk, forKey: "user_pk")
                self.performSegue(withIdentifier: "segMain", sender: self)
            }else{
                
            }
            
        }
    }
    class item_code{
        let msg1 : String
        init(msg1: String) {
            self.msg1 = msg1
        }
    }
    class item_user{
        let pk : String
        init(pk: String) {
            self.pk = pk
        }
    }
    func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyz0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
}

