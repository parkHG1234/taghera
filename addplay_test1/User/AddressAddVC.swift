//
//  AddressAddVC.swift
//  addplay_test1
//
//  Created by 08liter on 12/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import UIKit

class AddressAddVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addressWeb(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddressWebVC") as? AddressWebVC
        vc?.AddressWebVCDelegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}


extension AddressAddVC: AddressWebVCDelegate{
    func address(str: String) {
        print(str)
    }
    
    
    
    
}
