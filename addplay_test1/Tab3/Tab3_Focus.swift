//
//  Tab3_Focus.swift
//  addplay_test1
//
//  Created by MC976-002 on 22/03/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import WebKit
class Tab3_Focus: UIViewController, UIWebViewDelegate ,UIScrollViewDelegate{
    var GoodsPk:String = "62"
    var Array_review = [model_review]()
    var Array_product = [model_product]()
    let preferences = UserDefaults.standard
    var user_pk:String = "434"
    
    @IBOutlet weak var ui_txt_title: UILabel!
    @IBOutlet weak var ui_img_main: UIImageView!
    @IBOutlet weak var ui_img_category: UIImageView!
    @IBOutlet weak var ui_img_company: UIImageView!
    @IBOutlet weak var ui_txt_company_title: UILabel!
    @IBOutlet weak var ui_txt_percent: UILabel!
    @IBOutlet weak var ui_txt_price_org: UILabel!
    @IBOutlet weak var ui_txt_price_app: UILabel!
    @IBOutlet weak var ui_web_review: UIWebView!
    
    var str_maxCount:String = ""
    var str_particiCount:String = ""
    var str_username:String = ""
    var str_userphone:String = ""
    var str_useremail:String = ""
    var str_usergrade:String = ""
    var str_userchannel:String = ""
    var str_address_pk:String = ""
    var str_address_title:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //user_pk = self.preferences.string(forKey: "user_pk")!
        http_review()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webViewResizeToContent(webView: self.ui_web_review)
    }
    func webViewResizeToContent(webView: UIWebView) {
        webView.layoutSubviews()

        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame

        var height:CGFloat = webView.scrollView.contentSize.height

        ui_web_review.frame.size.height = height
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: height)
        webView.addConstraint(heightConstraint)

        // Set layout flag
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    
    func http_review(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Review_Focus.jsp?Data1="+GoodsPk).responseJSON{(responseData) -> Void in
            
            let Data = JSON(responseData.result.value!)
            
            print(responseData.result.value!)
            
            if let resData = Data["List"].arrayObject{
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    
                    self.Array_review.append(model_review(pk: dict["msg1"] as! String,
                                                      category: dict["msg3"] as! String,
                                                      url_pk: dict["msg5"] as! String,
                                                      url_category: dict["msg6"] as! String,
                                                      video_url: dict["msg7"] as! String,
                                                      picture: dict["msg8"] as! String,
                                                      contents: dict["msg9"] as! String,
                                                      user_pk: dict["msg10"] as! String,
                                                      contents_url: dict["msg11"] as! String))
                }
                self.http_product(product_pk: self.Array_review[0].category)
                self.setup_review()
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
    
    func http_product(product_pk: String){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_Focus.jsp?Data1="+product_pk).responseJSON{(responseData) -> Void in
            
            let Data = JSON(responseData.result.value!)
            
            print(responseData.result.value!)
            
            if let resData = Data["List"].arrayObject{
                
                arrRes = resData as! [[String:AnyObject]]
            }
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array_product.append(model_product(pk: dict["msg1"] as! String,
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
                self.setup_product()
            }else{
                Toast.shared.long(self.view, msg: "잠시 후 다시 시도해주세요")
            }
        }
    }
    
    func setup_review(){
        //상품 이미지 셋팅
        ui_img_main.sd_setImage(with: URL(string: self.Array_review[0].picture))
        ui_txt_title.text = self.Array_review[0].contents
        if(self.Array_review[0].url_category == "naver"){
            ui_img_category.image = UIImage(named: "naver_minicon")
        }
        else if(self.Array_review[0].url_category == "instar"){
             ui_img_category.image = UIImage(named: "instar_minicon")
        }
        else{
             ui_img_category.image = UIImage(named: "facebook_minicon")
        }
        
        ui_web_review.delegate = self
        ui_web_review.scalesPageToFit = true
        ui_web_review.contentMode = .scaleAspectFit
        //1. Load web site into my web view
        let myURL = URL(string: self.Array_review[0].contents_url)
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        ui_web_review.loadRequest(myURLRequest)
        
    }
    
    func setup_product(){
        //상품 이미지 셋팅
        ui_img_company.sd_setImage(with: URL(string: self.Array_product[0].video1_img_thumb))
        ui_txt_company_title.text = self.Array_product[0].title
        ui_txt_price_org.text = self.Array_product[0].price
        ui_txt_price_app.text = self.Array_product[0].price_add
    }
    
    func price_set(_price : String) -> String{
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        let price = Double(_price)!
        let result = numberformatter.string(from: NSNumber(value: price))
        
        return result!+""
    }
}


class model_review{
    let pk : String
    let category : String
    let url_pk : String
    let url_category : String
    let video_url : String
    let picture : String
    let contents : String
    let user_pk : String
    let contents_url : String
    init(pk: String, category: String, url_pk: String, url_category: String, video_url:String, picture:String, contents:String, user_pk:String, contents_url:String) {
        self.pk = pk
        self.category = category
        self.url_pk = url_pk
        self.url_category = url_category
        self.video_url = video_url
        self.picture = picture
        self.contents = contents
        self.user_pk = user_pk
        self.contents_url = contents_url
    }
}


