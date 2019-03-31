//
//  Main_Table.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 4. 20..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
extension Main_Table: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = ui_table_maintable.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as! Main_Table_Cell
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.ui_img_goods.sd_setImage(with: URL(string: Array[indexPath.row].video_img))
        cell.ui_img_brand.sd_setImage(with: URL(string: Array[indexPath.row].file_path))
        cell.ui_img_brand.clipsToBounds = true
        cell.ui_img_brand.layer.cornerRadius = cell.ui_img_brand.frame.size.width / 2
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension Main_Table: UITableViewDelegate{
    
}
class Main_Table: UIViewController {
    
    @IBOutlet weak var ui_table_maintable: UITableView!
    var Array = [item]()
    var GoodsPk:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarItem()
        ui_table_maintable.dataSource = self
        ui_table_maintable.delegate = self
        self.ui_table_maintable.rowHeight = 270
        
        http();
    }
    private func setNavigationbarItem() {
        let supportVie = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        let logo = UIImageView(image: #imageLiteral(resourceName: "tab1_title.png") )
        logo.frame = CGRect(x: 0, y: 0, width: supportVie.frame.size.width, height: supportVie.frame.size.height)
        logo.contentMode = .scaleAspectFit
        supportVie.addSubview(logo)
        navigationItem.titleView = supportVie
    }
    func http() {
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Main_Tab1_List.jsp").responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array.append(item(pk: dict["msg1"] as! String,
                                           file_path: dict["msg2"] as! String,
                                           video_img: dict["msg3"] as! String,
                                           title: dict["msg4"] as! String,
                                           contents: dict["msg5"] as! String,
                                           null: dict["msg6"] as! String,
                                           category: dict["msg7"] as! String,
                                           deadline: dict["msg8"] as! String,
                                           status: dict["msg9"] as! String))
                }
            }else{
                self.Array.append(item(pk: "",file_path: "",video_img: "",title: "데이터가 존재하지않습니다",contents: "",null: "",category: "",deadline: "",status: ""))
            }
            self.ui_table_maintable.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segGoodsFocus"){
            if let indexPath = ui_table_maintable.indexPathForSelectedRow{
                let param = segue.destination as! Experience_Focus
                param.GoodsPk = self.Array[indexPath.row].pk
            }
        }
    }
    
}
class item {
    let pk : String
    let file_path : String
    let video_img : String
    let title : String
    let contents : String
    let null : String
    let category : String
    let deadline : String
    let status : String
    init(pk: String, file_path: String, video_img: String, title: String, contents: String, null: String, category: String, deadline: String, status: String) {
        self.pk = pk
        self.file_path = file_path
        self.video_img = video_img
        self.title = title
        self.contents = contents
        self.null = null
        self.category = category
        self.deadline = deadline
        self.status = status
    }
}



