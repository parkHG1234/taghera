//
//  Tab4_List.swift
//  addplay_test1
//
//  Created by MC976-002 on 12/03/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON



//User_MyActivity_Book_List
class Tab4_List: UIViewController {
    var user_pk:String = ""
    let preferences = UserDefaults.standard
    var Array_user = [item_tab4_user]()
    var Array_list = [item_tab4_list]()
    @IBOutlet var ui_table_list4: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        user_pk = self.preferences.string(forKey: "user_pk")!
        
        setNavigationbarItem()
        ui_table_list4.dataSource = self
        ui_table_list4.delegate = self
        self.ui_table_list4.separatorStyle = .none
        //self.ui_table_list4.rowHeight = UITableViewAutomaticDimension
        //ui_table_list4.estimatedRowHeight = 300
        http_user()
//        http_list()
    }

    // MARK: - Table view data source
    private func setNavigationbarItem() {
        let supportVie = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        let logo = UIImageView(image: #imageLiteral(resourceName: "tab1_title.png") )
        logo.frame = CGRect(x: 0, y: 0, width: supportVie.frame.size.width, height: supportVie.frame.size.height)
        logo.contentMode = .scaleAspectFit
        supportVie.addSubview(logo)
        navigationItem.titleView = supportVie
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
                    self.Array_user.append(item_tab4_user(email: dict["msg5"] as! String,
                                                           phone: dict["msg4"] as! String))
                }
            }
            self.ui_table_list4.reloadData()
        }
    }
    
    func http_list() {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/User_MyActivity_List.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
         
            if arrRes.count > 2{
                for i in 0...(arrRes.count-1)/3{
                    var dict1 = arrRes[i*3]
                    var dict2 = arrRes[i*3+1]
                    var dict3 = arrRes[i*3+2]
                    self.Array_list.append(item_tab4_list(pk1: dict1["msg1"] as! String, img1: dict1["msg2"] as! String, status1: dict1["msg3"] as! String, goodspk1: dict1["msg4"] as! String, pk2: dict2["msg1"] as! String, img2: dict2["msg2"] as! String, status2: dict2["msg3"] as! String, goodspk2: dict2["msg4"] as! String, pk3: dict3["msg1"] as! String, img3: dict3["msg2"] as! String, status3: dict3["msg3"] as! String, goodspk3: dict3["msg4"] as! String))
                }
            }
            if(arrRes.count%3 == 1){
               var dict1 = arrRes[arrRes.count-1]
               self.Array_list.append(item_tab4_list(pk1: dict1["msg1"] as! String, img1: dict1["msg2"] as! String, status1: dict1["msg3"] as! String, goodspk1: dict1["msg4"] as! String, pk2: "", img2: "", status2: "", goodspk2: "", pk3: "", img3: "", status3: "", goodspk3: ""))
                print(dict1["msg1"] as! String)
            }
            if(arrRes.count%3 == 2){
                var dict1 = arrRes[arrRes.count-2]
                 var dict2 = arrRes[arrRes.count-1]
                 self.Array_list.append(item_tab4_list(pk1: dict1["msg1"] as! String, img1: dict1["msg2"] as! String, status1: dict1["msg3"] as! String, goodspk1: dict1["msg4"] as! String, pk2: dict2["msg1"] as! String, img2: dict2["msg2"] as! String, status2: dict2["msg3"] as! String, goodspk2: dict2["msg4"] as! String, pk3: "", img3: "", status3: "", goodspk3: ""))
            }
            self.ui_table_list4.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     
    }
}


extension Tab4_List: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array_user.count+Array_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
            let cell = ui_table_list4.dequeueReusableCell(withIdentifier: "Tab4_List_Cell_User", for: indexPath) as! Tab4_List_Cell_User
            // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
            //            cell.label_phone.text = Array_user[indexPath.row].phone
            if(Array_user[indexPath.row].email==""){
                cell.label_email.text = "이메일이 표시됩니다"
            }else{
                cell.label_email.text = Array_user[indexPath.row].email
            }
            // let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            //cell.btn_setting.addGestureRecognizer(tap)
            self.ui_table_list4.rowHeight = 280
            
            return cell
        }
        else{
            // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
            let cell = ui_table_list4.dequeueReusableCell(withIdentifier: "Tab4_List_Cell_List", for: indexPath) as! Tab4_List_Cell_List
            // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
            cell.tab4_img1.sd_setImage(with: URL(string: Array_list[indexPath.row-1].img1))
            cell.tab4_img2.sd_setImage(with: URL(string: Array_list[indexPath.row-1].img2))
            cell.tab4_img3.sd_setImage(with: URL(string: Array_list[indexPath.row-1].img3))
            if(Array_list[indexPath.row-1].status1 == "wait"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "선정 중"
            }else if(Array_list[indexPath.row-1].status1 == "booked"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "예약완료"
            }
            else if(Array_list[indexPath.row-1].status1 == "book"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "예약 중"
            }
            else if(Array_list[indexPath.row-1].status1 == "choice"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "선정"
            }
            else if(Array_list[indexPath.row-1].status1 == "delivery"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "배송 중"
            }
            else if(Array_list[indexPath.row-1].status1 == "review"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "작성 중"
            }
            else if(Array_list[indexPath.row-1].status1 == "check"){
                cell.tab4_img1_br.isHidden = false
                cell.tab4_txt1.text = "승인 중"
            }
            else{
                cell.tab4_img1_br.isHidden = true
                cell.tab4_txt1.isHidden = true
            }
            
            if(Array_list[indexPath.row-1].status2 == "wait"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "선정 중"
            }else if(Array_list[indexPath.row-1].status2 == "booked"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "예약완료"
            }
            else if(Array_list[indexPath.row-1].status2 == "book"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "예약 중"
            }
            else if(Array_list[indexPath.row-1].status2 == "choice"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "선정"
            }
            else if(Array_list[indexPath.row-1].status2 == "delivery"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "배송 중"
            }
            else if(Array_list[indexPath.row-1].status2 == "review"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "작성 중"
            }
            else if(Array_list[indexPath.row-1].status2 == "check"){
                cell.tab4_img2_br.isHidden = false
                cell.tab4_txt2.text = "승인 중"
            }
            else{
                cell.tab4_img2_br.isHidden = true
                cell.tab4_txt2.isHidden = true
            }
            
            if(Array_list[indexPath.row-1].status3 == "wait"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "선정 중"
            }else if(Array_list[indexPath.row-1].status3 == "booked"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "예약완료"
            }
            else if(Array_list[indexPath.row-1].status3 == "book"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "예약 중"
            }
            else if(Array_list[indexPath.row-1].status3 == "choice"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "선정"
            }
            else if(Array_list[indexPath.row-1].status3 == "delivery"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "배송 중"
            }
            else if(Array_list[indexPath.row-1].status3 == "review"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "작성 중"
            }
            else if(Array_list[indexPath.row-1].status3 == "check"){
                cell.tab4_img3_br.isHidden = false
                cell.tab4_txt3.text = "승인 중"
            }
            else{
                cell.tab4_img3_br.isHidden = true
                cell.tab4_txt3.isHidden = true
            }
            
            self.ui_table_list4.rowHeight = cell.tab4_img1.frame.height
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
class item_tab4_user{
    let email : String
    let phone : String
    init(email: String, phone: String) {
        self.email = email
        self.phone = phone
    }
}
class item_tab4_list{
    let pk1 : String
    let img1 : String
    var status1 : String
    let goodspk1 : String
    
    let pk2 : String
    let img2 : String
    let status2 : String
    let goodspk2 : String
    
    let pk3 : String
    let img3 : String
    let status3 : String
    let goodspk3 : String
    init(pk1: String, img1: String, status1: String, goodspk1: String, pk2: String, img2: String, status2: String, goodspk2: String,pk3: String, img3: String, status3: String, goodspk3: String) {
        self.pk1 = pk1
        self.img1 = img1
        self.status1 = status1
        self.goodspk1 = goodspk1
        
        self.pk2 = pk2
        self.img2 = img2
        self.status2 = status2
        self.goodspk2 = goodspk2
        
        self.pk3 = pk3
        self.img3 = img3
        self.status3 = status3
        self.goodspk3 = goodspk3
    }
}
