//
//  Experience_Focus.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 4. 26..
//  Copyright © 2018년 MC975-003. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import WebKit

class Experience_Focus: UIViewController, UIWebViewDelegate ,UIScrollViewDelegate{
    var GoodsPk:String = ""
    var Array = [model_product]()
    var Array_user = [model_user]()
    var Array_address = [model_address]()
    let preferences = UserDefaults.standard
    var user_pk:String = ""
    let dateFormatter = DateFormatter()
    var countdownTimer: Timer!
    var currentTime:Int = 0
    var deadLine:Int = 0
    
    
    // 기본화면
    var str_maxCount:String = ""
    var str_particiCount:String = ""
    var str_username:String = ""
    var str_userphone:String = ""
    var str_useremail:String = ""
    var str_usergrade:String = ""
    var str_userchannel:String = ""
    var str_address_pk:String = ""
    var str_address_title:String = ""
    
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var product_title: UILabel!
    @IBOutlet weak var product_intro: UILabel!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var requestView: UIView!
    
    @IBAction func product_detail(_ sender: UIButton) {
    }
    
    @IBAction func request(_ sender: UIButton) {
    }
    @IBAction func requestViewExit(_ sender: Any) {
        self.requestView.isHidden = true
    }
    @IBAction func goToExperience(_ sender: Any) {
        self.requestView.isHidden = false
    }
    
    // 배송지 설정
    
    @IBOutlet weak var deliver_option_tf: UITextField!
    @IBOutlet weak var deliver_name_tf: UITextField!
    @IBOutlet weak var deliver_mail_tf: UITextField!
    
    @IBOutlet weak var deliver_destination_lb: UILabel!
    
    @IBOutlet weak var deliver_phone_tf: UITextField!
    @IBOutlet weak var deliver_channel_tf: UITextField!
    
    var pickOption = ["1", "2", "3", "4", "5"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_pk = self.preferences.string(forKey: "user_pk")!
        http()
        http_user()
        http_address()
        
        pickerView.delegate = self
        deliver_option_tf.inputView = pickerView
        
    }
    func http(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_Focus.jsp?Data1="+GoodsPk).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    
                    self.Array.append(model_product(pk: dict["msg1"] as! String,
                                                           product_pk: dict["msg2"] as! String,
                                                           brand_profile: dict["msg3"] as! String,
                                                           brand_name: dict["msg4"] as! String,
                                                           brand_url: dict["msg5"] as! String,
                                                           title: dict["msg6"] as! String,
                                                           contents: dict["msg7"] as! String,
                                                           deadline: dict["msg8"] as! String,
                                                           particicount: dict["msg9"] as! String,
                                                           maxcount: dict["msg10"] as! String,
                                                           arrive: dict["msg11"] as! String,
                                                           hashtag: dict["msg12"] as! String,
                                                           price: dict["msg13"] as! String,
                                                           video1_img: dict["msg14"] as! String,
                                                           video1_url: dict["msg15"] as! String,
                                                           price_add: dict["msg16"] as! String,
                                                           purchage_url: dict["msg17"] as! String,
                                                           image: dict["msg18"] as! String,
                                                           video1_img_main: dict["msg19"] as! String,
                                                           video1_img_thumb: dict["msg20"] as! String,
                                                           reivew_count: dict["msg21"] as! String,
                                                           status: dict["msg22"] as! String))
                }
                self.viewsetup()
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
    func http_user(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/User.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            
            print(responseData)
            let Data = JSON(responseData.result.value!)
            
            if let resData = Data["List"].arrayObject{
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    
                    self.Array_user.append(model_user(pk: dict["msg1"] as! String,
                                                           name: dict["msg3"] as! String,
                                                           phone: dict["msg4"] as! String,
                                                           email: dict["msg5"] as! String,
                                                           grade: dict["msg11"] as! String,
                                                           channel: dict["msg12"] as! String))
                }
                self.setup_user()
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
    
    func setup_user(){
        // black 등급 일 경우 이용제한
        str_usergrade = self.Array_user[0].grade
        
        str_username = self.Array_user[0].name
        str_userphone = self.Array_user[0].phone
        str_useremail = self.Array_user[0].email
        str_userchannel = self.Array_user[0].channel
        
        deliver_name_tf.text = str_username
        deliver_mail_tf.text = str_useremail
        deliver_phone_tf.text = str_userphone
        deliver_channel_tf.text = str_userchannel
    }
    func http_address(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Address_Basic.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            
            let Data = JSON(responseData.result.value!)
            
            print(responseData.result.value!)
            
            if let resData = Data["List"].arrayObject{
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    
                    self.Array_address.append(model_address(pk: dict["msg1"] as! String,
                                                      title: dict["msg2"] as! String))
                }
                self.setup_address()
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
    
    func setup_address(){
        self.str_address_pk = self.Array_address[0].pk
        self.str_address_title = self.Array_address[0].title
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        endTimer()
    }
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    func endTimer() {
        countdownTimer.invalidate()
    }

    @objc func updateTime() {
        timer.text = "\(timeFormatted(deadLine - currentTime))"
        if deadLine != 0 {
            deadLine -= 1
        } else {
            endTimer()
        }
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        if(totalSeconds < 0 ){
            endTimer()
            return String(format: "%02d:%02d:%02d",0, 0, 0)
        }
        let day : Int = totalSeconds / 86400
        let hours: Int = (totalSeconds % 86400) / 3600
        let minutes: Int = (totalSeconds % 86400) % 3600 / 60
        let seconds: Int = ((totalSeconds % 86400) % 3600) % 60
        if(day<1){
            return String(format: "%02d:%02d:%02d",hours, minutes, seconds)
        }else if(day < 1 && hours < 1){
            return String(format: "%02d:%02d:%02d",0 , minutes, seconds)
        }else if(day < 1 && hours < 1 && minutes < 1){
            return String(format: "%02d:%02d:%02d",0 , 0, seconds)
        }else if(day < 1 && hours < 1 && minutes < 1 && seconds < 1){
            endTimer()
            return String(format: "%02d:%02d:%02d",0, 0, 0)
        }else{
            return String(format: "%d일%02d:%02d:%02d",day, hours, minutes, seconds)
        }
    }
    
    
    func viewsetup(){
        // 타이머
        var now = Date()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        let kr = dateFormatter.string(from: now)
        self.currentTime = Int(kr)!
        self.deadLine = Int(self.Array[0].deadline)!
        startTimer()
        
        // 이미지
        self.imageview.af_setImage(withURL: URL(string: self.Array[0].video1_img_main)!)

        // 가격
        self.price.text = "￦"+price_set(_price: self.Array[0].price)
        
        //참여자수 셋팅
        str_maxCount = self.Array[0].maxcount
        str_particiCount = self.Array[0].particicount
        self.counter.text = "참여 " + str_particiCount + " / 선정 " + str_maxCount
        
        
        self.product_title.text = "["+self.Array[0].brand_name+"]"+self.Array[0].title
        self.product_intro.text = self.Array[0].contents
        
        //웹뷰
        webview.contentMode = .scaleAspectFit
        let url = URL(string: self.Array[0].purchage_url)
        let requestObj = URLRequest(url: url! as URL)
        webview.loadRequest(requestObj)
    }
    
    func price_set(_price : String) -> String{
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        let price = Double(_price)!
        let result = numberformatter.string(from: NSNumber(value: price))
        
        return result!+""
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segFinish"){
            let parameters = [
                "Data1": GoodsPk,
                "Data2": user_pk
            ]
            Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_Ios_Apply.jsp", method: .post, parameters: parameters)
            
            let param = segue.destination as! Experience_Finish
            //param1.GoodsPk = self.Array[0].pk
        }
        else if (segue.identifier == "segInfo"){
            let param1 = segue.destination as! Experience_Info
            param1.GoodsPk = self.Array[0].pk
        }
        else if (segue.identifier == "segaddress"){
            let param1 = segue.destination as! address_list
        }
    }
}


extension Experience_Focus : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.deliver_option_tf.text = self.pickOption[row]
        self.view.endEditing(true)
    }

//    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
//    {
//           self.deliver_option_tf.text = self.pickOption[row]
//        self.view.endEditing(true)
//
//    }
//
    }
class model_product{
    let pk : String
    let product_pk : String
    let brand_profile : String
    let brand_name : String
    let brand_url : String
    let title : String
    let contents : String
    let deadline : String
    let particicount : String
    let maxcount : String
    let arrive : String
    let hashtag : String
    let price : String
    let video1_img : String
    let video1_url : String
    let price_add : String
    let purchage_url : String
    let image : String
    let video1_img_main : String
    let video1_img_thumb : String
    let reivew_count : String
    let status : String
    init(pk: String, product_pk: String, brand_profile: String, brand_name: String, brand_url: String, title: String, contents: String, deadline: String, particicount: String, maxcount: String, arrive: String, hashtag: String, price: String, video1_img: String, video1_url: String, price_add: String
        , purchage_url: String, image: String, video1_img_main: String, video1_img_thumb: String, reivew_count: String, status: String) {
        self.pk = pk
        self.product_pk = product_pk
        self.brand_profile = brand_profile
        self.brand_name = brand_name
        self.brand_url = brand_url
        self.title = title
        self.contents = contents
        self.deadline = deadline
        self.particicount = particicount
        self.maxcount = maxcount
        self.arrive = arrive
        self.hashtag = hashtag
        self.price = price
        self.video1_img = video1_img
        self.video1_url = video1_url
        self.price_add = price_add
        self.purchage_url = purchage_url
        self.image = image
        self.video1_img_main = video1_img_main
        self.video1_img_thumb = video1_img_thumb
        self.reivew_count = reivew_count
        self.status = status
    }
}
class model_user{
    let pk : String
    let name : String
    let email : String
    let grade : String
    let channel : String
    let phone : String
    init(pk: String, name: String, phone: String, email: String, grade: String, channel: String) {
        self.pk = pk
        self.name = name
        self.phone = phone
        self.email = email
        self.grade = grade
        self.channel = channel
    }
}
class model_address{
    let pk : String
    let title : String
    init(pk: String, title: String) {
        self.pk = pk
        self.title = title
    }
}

