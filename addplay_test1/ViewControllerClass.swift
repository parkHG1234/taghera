//
//  ViewControllerClass.swift
//  addplay_test1
//
//  Created by 08liter on 10/04/2019.
//  Copyright © 2019 MC975-003. All rights reserved.
//

import Foundation
import Alamofire

extension UIViewController{
    
    
    func keyboardHide(textField: UITextField){
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.blue
        
        textField.inputAccessoryView = toolBarKeyboard
    }
    
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    func commonAlert(message: String) -> UIAlertController{
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction( UIAlertAction(title: "확인", style: .default))
        return alertController
    }

}
