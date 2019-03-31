//
//  Tab3_List.swift
//  addplay_test1
//
//  Created by MC976-002 on 26/02/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
extension Tab3_List: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = ui_table_list3.dequeueReusableCell(withIdentifier: "Tab3_List_Cell", for: indexPath) as! Tab3_List_Cell
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.img1.sd_setImage(with: URL(string: Array[indexPath.row].img1))
        cell.img2.sd_setImage(with: URL(string: Array[indexPath.row].img2))
        cell.img3.sd_setImage(with: URL(string: Array[indexPath.row].img3))
        cell.img4.sd_setImage(with: URL(string: Array[indexPath.row].img4))
        cell.img5.sd_setImage(with: URL(string: Array[indexPath.row].img5))
        cell.img6.sd_setImage(with: URL(string: Array[indexPath.row].img6))
        cell.img7.sd_setImage(with: URL(string: Array[indexPath.row].img7))
        cell.img8.sd_setImage(with: URL(string: Array[indexPath.row].img8))
        cell.img9.sd_setImage(with: URL(string: Array[indexPath.row].img9))
        cell.img10.sd_setImage(with: URL(string: Array[indexPath.row].img10))
        cell.img11.sd_setImage(with: URL(string: Array[indexPath.row].img11))
        cell.img12.sd_setImage(with: URL(string: Array[indexPath.row].img12))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension Tab3_List: UITableViewDelegate{
    
}
class Tab3_List: UIViewController{
    @IBOutlet weak var ui_table_list3: UITableView!
    var Array = [item_tab3_list]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbarItem()
        ui_table_list3.dataSource = self
        ui_table_list3.delegate = self
        self.ui_table_list3.rowHeight = 800
        http()
        
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
        Alamofire.request("http://13.209.148.229/Web_Taghera/Main_Tab3.jsp").responseJSON{(responseData) -> Void in
            let Data = JSON(responseData.result.value!)
            if let resData = Data["List"].arrayObject{
                arrRes = resData as! [[String:AnyObject]]
            }
            var count = 0
            if arrRes.count > 12{
                for i in 0...((arrRes.count)/12)-1{
                    var dict1 = arrRes[count]
                    var dict2 = arrRes[count+1]
                    var dict3 = arrRes[count+2]
                    var dict4 = arrRes[count+3]
                    var dict5 = arrRes[count+4]
                    var dict6 = arrRes[count+5]
                    var dict7 = arrRes[count+6]
                    var dict8 = arrRes[count+7]
                    var dict9 = arrRes[count+8]
                    var dict10 = arrRes[count+9]
                    var dict11 = arrRes[count+10]
                    var dict12 = arrRes[count+11]
                    self.Array.append(item_tab3_list(pk1: dict1["msg1"] as! String,
                                                     img1: dict1["msg2"] as! String,pk2: dict2["msg1"] as! String,
                                                     img2: dict2["msg2"] as! String,pk3: dict3["msg1"] as! String,
                                                     img3: dict3["msg2"] as! String,pk4: dict4["msg1"] as! String,
                                                     img4: dict4["msg2"] as! String,pk5: dict5["msg1"] as! String,
                                                     img5: dict5["msg2"] as! String,pk6: dict6["msg1"] as! String,
                                                     img6: dict6["msg2"] as! String,pk7: dict7["msg1"] as! String,
                                                     img7: dict7["msg2"] as! String,pk8: dict8["msg1"] as! String,
                                                     img8: dict8["msg2"] as! String,pk9: dict9["msg1"] as! String,
                                                     img9: dict9["msg2"] as! String,pk10: dict10["msg1"] as! String,
                                                     img10: dict10["msg2"] as! String,pk11: dict11["msg1"] as! String,
                                                     img11: dict11["msg2"] as! String,pk12: dict12["msg1"] as! String,
                                                     img12: dict12["msg2"] as! String
                                           ))
                    count += 12
                }
            }
        self.ui_table_list3.reloadData()
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "seg_focus"){
            if let indexPath = ui_table_list3.indexPathForSelectedRow{
                let param = segue.destination as! Tab3_Focus
                //param.GoodsPk = self.Array[indexPath.row].pk
            }
        }
    }
}
class item_tab3_list {
    let pk1 : String
    let img1 : String
    let pk2 : String
    let img2 : String
    let pk3 : String
    let img3 : String
    let pk4 : String
    let img4 : String
    let pk5 : String
    let img5 : String
    let pk6 : String
    let img6 : String
    let pk7 : String
    let img7 : String
    let pk8 : String
    let img8 : String
    let pk9 : String
    let img9 : String
    let pk10 : String
    let img10 : String
    let pk11 : String
    let img11 : String
    let pk12 : String
    let img12 : String
    init(pk1: String, img1: String,pk2: String, img2: String, pk3: String, img3: String,pk4: String, img4: String,pk5: String, img5: String,pk6: String, img6: String,pk7: String, img7: String,pk8: String, img8: String,pk9: String, img9: String,pk10: String, img10: String,pk11: String, img11: String,pk12: String, img12: String) {
        self.pk1 = pk1
        self.img1 = img1
        self.pk2 = pk2
        self.img2 = img2
        self.pk3 = pk3
        self.img3 = img3
        self.pk4 = pk4
        self.img4 = img4
        self.pk5 = pk5
        self.img5 = img5
        self.pk6 = pk6
        self.img6 = img6
        self.pk7 = pk7
        self.img7 = img7
        self.pk8 = pk8
        self.img8 = img8
        self.pk9 = pk9
        self.img9 = img9
        self.pk10 = pk10
        self.img10 = img10
        self.pk11 = pk11
        self.img11 = img11
        self.pk12 = pk12
        self.img12 = img12
    }
}


