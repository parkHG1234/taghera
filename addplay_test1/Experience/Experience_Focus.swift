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
import SwiftyJSON
import WebKit

class Experience_Focus: UIViewController, UIWebViewDelegate ,UIScrollViewDelegate{
    var GoodsPk:String = ""
    var Array = [model_product]()
    var Array_user = [model_user]()
    var Array_address = [model_address]()
    let preferences = UserDefaults.standard
    var user_pk:String = "434"
    @IBOutlet weak var ui_img: UIImageView!
    @IBOutlet weak var ui_txt_contents: UILabel!
    @IBOutlet weak var ui_txt_price: UILabel!
    @IBOutlet weak var ui_txt_partici: UILabel!
    @IBOutlet weak var ui_webview: UIWebView!
    @IBOutlet weak var ui_txt_companyname: UILabel!
    @IBOutlet weak var ui_layout_inputlayout: UIView!
    @IBOutlet weak var ui_scroll: UIScrollView!
    @IBOutlet weak var ui_edit_name: UITextField!
    @IBOutlet weak var ui_edit_email: UITextField!
    @IBOutlet weak var ui_edit_phone: UITextField!
    @IBOutlet weak var ui_edit_channel: UITextField!
    @IBOutlet weak var ui_txt_address: UILabel!
    
    var str_maxCount:String = ""
    var str_particiCount:String = ""
    var str_username:String = ""
    var str_userphone:String = ""
    var str_useremail:String = ""
    var str_usergrade:String = ""
    var str_userchannel:String = ""
    var str_address_pk:String = ""
    var str_address_title:String = ""
    
    var bool_layoutuser:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //user_pk = self.preferences.string(forKey: "user_pk")!
        http()
        http_user()
        http_address()
        
        ui_layout_inputlayout.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewResizeToContent(webView: self.ui_webview)
    }
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()
        
        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        var height:CGFloat = webView.scrollView.contentSize.height
        
        ui_webview.frame.size.height = height
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: height)
        webView.addConstraint(heightConstraint)
        
        // Set layout flag
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    @IBAction func ui_btn_input(_ sender: Any) {
        if(bool_layoutuser ==  false){
            bool_layoutuser = true
            self.ui_layout_inputlayout.isHidden = false
        }
        else{
            bool_layoutuser = false
            
            if (Int(str_maxCount)! * 3 <= Int(str_particiCount)!){
                Toast.shared.long(self.view, msg: "체험 신청 3배수 모집이 완료되었어요")
            }
            else{
                
                if(self.ui_edit_name.text == ""){
                    Toast.shared.long(self.view, msg: "이름을 입력해주세요.")
                }
                else{
                    if(self.ui_edit_email.text == ""){
                        Toast.shared.long(self.view, msg: "이메일을 입력해주세요.")
                    }
                    else{
                        if(self.ui_edit_phone.text == ""){
                            Toast.shared.long(self.view, msg: "연락처를 입력해주세요.")
                        }
                        else{
                            if(self.ui_edit_channel.text == ""){
                                Toast.shared.long(self.view, msg: "채널을 입력해주세요.")
                            }
                            else{
                                var result : String = " "
                                let parameters1 = [
                                    "Data1": user_pk,
                                    "Data2": GoodsPk
                                ]
                                Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_Overlap.jsp", method: .post, parameters: parameters1) .responseString { response in
                                    print("Success: \(response.result.isSuccess)")
                                    print("Response String: \(response.result.value)")
                                    result = response.result.value!
                                    if result.contains("overlap") {
                                        Toast.shared.long(self.view, msg: "이미 신청 중입니다.")
                                    }
                                    else {
                                        self.performSegue(withIdentifier: "seg_finish", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func ui_btn_Back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func ui_btn_inputCancel(_ sender: Any) {
        ui_layout_inputlayout.isHidden = true
    }
    @IBAction func ui_btn_address(_ sender: Any) {
    }
    func http(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_Focus.jsp?Data1="+GoodsPk).responseJSON{(responseData) -> Void in
            
            let Data = JSON(responseData.result.value!)
            
            print(responseData.result.value!)

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
            
            let Data = JSON(responseData.result.value!)
            
            print(responseData.result.value!)
            
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
    func viewsetup(){
        str_maxCount = self.Array[0].maxcount
        str_particiCount = self.Array[0].particicount
        
        //상품 이미지 셋팅
        ui_img.sd_setImage(with: URL(string: self.Array[0].video1_img_main))
        
        //회사 정보 / 상품 정보 셋팅
        ui_txt_companyname.text = "["+self.Array[0].brand_name+"] "+self.Array[0].title
        ui_txt_contents.text = self.Array[0].contents
        ui_txt_price.text = "￦"+price_set(_price: self.Array[0].price)
        
        //참여자수 셋팅
        ui_txt_partici.text = "참여 " + str_particiCount + " / 선정 " + str_maxCount
        
        ui_webview.delegate = self
        ui_webview.scalesPageToFit = true
        ui_webview.contentMode = .scaleAspectFit
        //1. Load web site into my web view
        let myURL = URL(string: self.Array[0].image)
        print(self.Array[0].image)
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        ui_webview.loadRequest(myURLRequest)

    }
    
    func setup_user(){
        str_username = self.Array_user[0].name.removingPercentEncoding!
        str_userphone = self.Array_user[0].phone.removingPercentEncoding!
        str_useremail = self.Array_user[0].email.removingPercentEncoding!
        str_usergrade = self.Array_user[0].grade
        str_userchannel = self.Array_user[0].channel.removingPercentEncoding!
        
        ui_edit_name.text = str_username
        ui_edit_phone.text = str_userphone
        ui_edit_email.text = str_useremail
        ui_edit_channel.text = str_userchannel
        //ui_txt_contents.text = self.Array[0].contents

        
    }
    func setup_address(){
        str_address_pk = self.Array_address[0].pk.removingPercentEncoding!
        str_address_title = self.Array_address[0].title.removingPercentEncoding!
        
        ui_txt_address.text = str_address_title
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

