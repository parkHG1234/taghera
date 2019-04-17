//
//  Tab4_VC.swift
//  addplay_test1
//
//  Created by 08liter on 16/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Tab4_VC: UIViewController{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var labelSelect: UILabel!
    @IBOutlet weak var labelComplete: UILabel!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var requestCollectionView: UICollectionView!
    
    let preferences = UserDefaults.standard
    var userArray = [User]()
    var requestArray = [User_MyActivity_Count]()
    var ListArray = [User_MyActivity_List]()
    var userPk = ""
    
    var reviewWritePk = ""
    var reviewWriteImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPk = self.preferences.string(forKey: "user_pk")!
        
        initUserData()
        initRequestData()
        initListData()
    }
    
    func initUserData(){
        var arrRes = [[String:AnyObject]]()
        let param = [
            "Data1":userPk
        ]
        Alamofire.request("http://13.209.148.229/Web_Taghera/User.jsp",method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON{(responseData) -> Void in
            print(responseData)
            if(responseData.result.value != nil){
                self.userArray.removeAll()
                let Data = JSON(responseData.result.value!)
                if let resData = Data["List"].arrayObject{
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                if arrRes.count > 0{
                    for i in 0...arrRes.count-1{
                        var dict = arrRes[i]
                        self.userArray.append(User(
                            str_profile: dict["msg8"] as! String,
                            str_name: dict["msg3"] as! String,
                            str_phone: dict["msg4"] as! String,
                            str_email: dict["msg5"] as! String,
                            grade: dict["msg11"] as! String,
                            str_point: dict["msg13"] as! String))
                    }
                }
                self.initUserLayout()
            }else{
                
            }
        }
    }
    
    func initUserLayout(){
        self.labelId.text = userArray[0].str_phone
        self.labelMail.text = userArray[0].str_email
        self.profileImage.af_setImage(withURL: URL(string: self.userArray[0].str_profile)!)
    }
    
    func initRequestData(){
        var arrRes = [[String:AnyObject]]()
        let param = [
            "Data1":userPk
        ]
        Alamofire.request("http://13.209.148.229/Web_Taghera/User_MyActivity_Count.jsp",method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON{(responseData) -> Void in
            if(responseData.result.value != nil){
                self.requestArray.removeAll()
                let Data = JSON(responseData.result.value!)
                if let resData = Data["List"].arrayObject{
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                if arrRes.count > 0{
                    for i in 0...arrRes.count-1{
                        var dict = arrRes[i]
                        self.requestArray.append(User_MyActivity_Count(
                            strRequest: dict["msg2"] as! String,
                            strSelect: dict["msg3"] as! String,
                            strComplete: dict["msg4"] as! String))
                    }
                }
                self.initRequestLayout()
            }else{
                
            }
        }
    }
    func initRequestLayout(){
        self.labelRequest.text = requestArray[0].strRequest
        self.labelSelect.text = requestArray[0].strSelect
        self.labelComplete.text = requestArray[0].strComplete
    }
    
//    User_MyActivity_Count
    func initListData(){
        var arrRes = [[String:AnyObject]]()
        let param = [
            "Data1":userPk
        ]
        Alamofire.request("http://13.209.148.229/Web_Taghera/User_MyActivity_List.jsp",method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON{(responseData) -> Void in
            if(responseData.result.value != nil){
                self.ListArray.removeAll()
                let Data = JSON(responseData.result.value!)
                if let resData = Data["List"].arrayObject{
                    arrRes = resData as! [[String:AnyObject]]
                }
                
                if arrRes.count > 0{
                    for i in 0...arrRes.count-1{
                        var dict = arrRes[i]
                        self.ListArray.append(User_MyActivity_List(
                            pk: dict["msg1"] as! String,
                            image: dict["msg2"] as! String,
                            status: dict["msg3"] as! String,
                            goodsPk: dict["msg4"] as! String))
                    }
                }
                self.requestCollectionView.reloadData()
            }else{
                
            }
        }
        
    }

}

extension Tab4_VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCell", for: indexPath) as! requestCell
        cell.Image.af_setImage(withURL: URL(string: self.ListArray[indexPath.row].image)!)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = cell.Image.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        if(self.ListArray[indexPath.row].status == "wait"){
            cell.Image.addSubview(blurEffectView)
            cell.text.text = "선정 중"
        }else if(self.ListArray[indexPath.row].status == "succed"){
            cell.Image.addSubview(blurEffectView)
            cell.text.text = "예약완료"
        }else if(self.ListArray[indexPath.row].status == "review"){
            cell.Image.addSubview(blurEffectView)
            cell.text.text = "작성 중"
        }else if(self.ListArray[indexPath.row].status == "check"){
            cell.Image.addSubview(blurEffectView)
            cell.text.text = "승인 중"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 2
        let height = collectionView.frame.width / 3 - 2
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.ListArray[indexPath.row].status == "wait"){
        }else if(self.ListArray[indexPath.row].status == "succed"){

        }else if(self.ListArray[indexPath.row].status == "review"){
            reviewWritePk = self.ListArray[indexPath.row].pk
            reviewWriteImage = self.ListArray[indexPath.row].image
            self.performSegue(withIdentifier: "ReviewWriteVC", sender: self)
        }else if(self.ListArray[indexPath.row].status == "check"){
            Toast.shared.long(self.view, msg: "관리자 승인 중이에요")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ReviewWriteVC"){
            let ReviewWriteVC = segue.destination as! ReviewWriteVC
            ReviewWriteVC.Pk = self.reviewWritePk
            ReviewWriteVC.Image = self.reviewWriteImage
        }
    }
}

class requestCell: UICollectionViewCell{
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var text: UILabel!
}
