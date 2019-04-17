//
//  Experience_Info.swift
//  addplay_test1
//
//  Created by MC975-003 on 2018. 5. 9..
//  Copyright © 2018년 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
extension Experience_Info: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = ui_table.dequeueReusableCell(withIdentifier: "ExperienceInfoCell", for: indexPath) as! Experience_Info_Cell
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.ui_txt.text = Array[indexPath.row].title
        cell.ui_contents.numberOfLines = 0
        cell.ui_contents.text = Array[indexPath.row].content
        cell.ui_contents.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension Experience_Info: UITableViewDelegate{
    
}
class Experience_Info: UIViewController {
    
    @IBOutlet weak var ui_table: UITableView!
    var Array = [item_experience_info]()
    var GoodsPk = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ui_table.separatorStyle = .none
        self.ui_table.tableFooterView = UIView(frame: .zero)
        ui_table.dataSource = self
        ui_table.delegate = self
        //self.ui_table.rowHeight = 270
        print(GoodsPk)
        http();
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func http(){
        var arrRes = [[String:AnyObject]]()
        Alamofire.request("http://13.209.148.229/Web_Taghera/Experience_GoodInfo.jsp?Data1="+GoodsPk).responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            print(responseData.result.value!)
            if arrRes.count > 0{
                for i in 0...arrRes.count-1{
                    var dict = arrRes[i]
                    self.Array.append(item_experience_info(pk: dict["msg1"] as! String,
                                           title: dict["msg2"] as! String,
                                           content: dict["msg3"] as! String))
                }
                
            }else{
            }
            self.ui_table.reloadData()
            self.ui_table.estimatedRowHeight = 500
            self.ui_table.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segExperienceInfo_Focus"){
            if let indexPath = ui_table.indexPathForSelectedRow{
                let param = segue.destination as! Experience_Info_Focus1
                param.Title = self.Array[indexPath.row].title
                param.Content = self.Array[indexPath.row].content
            }
        }
    }
}
class item_experience_info {
    let pk : String
    let title : String
    let content : String
    
    init(pk: String, title: String, content: String) {
        self.pk = pk
        self.title = title
        self.content = content
    }
}



