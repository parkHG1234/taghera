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
extension address_list: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = ui_table_list.dequeueReusableCell(withIdentifier: "id_cell_addresslist", for: indexPath) as! User_Address_Cell
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.ui_txt_title.text = Array_list[indexPath.row].address_title.removingPercentEncoding!
        cell.ui_txt_name.text = Array_list[indexPath.row].address_name.removingPercentEncoding!
        cell.ui_txt_address.text = Array_list[indexPath.row].address_txt.removingPercentEncoding!
        cell.ui_txt_addressfocus.text = Array_list[indexPath.row].address_focus.removingPercentEncoding!
        cell.ui_txt_phone.text = Array_list[indexPath.row].address_phone.removingPercentEncoding!
        
        self.ui_table_list.rowHeight = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension address_list: UITableViewDelegate{
    
}
class address_list: UIViewController {
    var user_pk:String = "434"
    let preferences = UserDefaults.standard
    var Array_list = [model_address1]()

    @IBOutlet weak var ui_table_list: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //user_pk = self.preferences.string(forKey: "user_pk")!
        
        ui_table_list.dataSource = self
        ui_table_list.delegate = self
        //self.ui_table_list4.rowHeight = UITableViewAutomaticDimension
        http()
    }

    func http() {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Address_List.jsp?Data1="+user_pk).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array_list.append(model_address1(pk: dict["msg1"] as! String,
                                           user_pk: dict["msg2"] as! String,
                                           address_title: dict["msg3"] as! String,
                                           address_num: dict["msg4"] as! String,
                                           address_txt: dict["msg5"] as! String,
                                           address_focus: dict["msg6"] as! String,
                                           address_name: dict["msg7"] as! String,
                                           address_phone: dict["msg8"] as! String,
                                           status: dict["msg9"] as! String))
                }
            }else{
                
            }
            self.ui_table_list.reloadData()
        }
    }
    @IBAction func ui_btn_back(_ sender: Any) {
         self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

class model_address1 {
    let pk : String
    let user_pk : String
    let address_title : String
    let address_num : String
    let address_txt : String
    let address_focus : String
    let address_name : String
    let address_phone : String
    let status : String
    init(pk: String, user_pk: String, address_title: String, address_num: String, address_txt: String, address_focus: String, address_name: String, address_phone: String, status: String) {
        self.pk = pk
        self.user_pk = user_pk
        self.address_title = address_title
        self.address_num = address_num
        self.address_txt = address_txt
        self.address_focus = address_focus
        self.address_name = address_name
        self.address_phone = address_phone
        self.status = status
    }
}
