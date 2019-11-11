//
//  ForgotPasswordViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD


class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var emailText: TextFieldRoudedBorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Back Button with UIImage
        customBackButton()
        
        //Hide Keyboard on outside tap
        self.hideKeyboard()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        errorMessage.text = ""
        
        if emailText.text == "" {
            ProgressHUD.showError("Email Field is Required")
        }else{
            
            let email = emailText.text!
            
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                     ProgressHUD.showSuccess("A Reset Password Has Been Sent To Your Email")
                }else{
                    ProgressHUD.showError(error?.localizedDescription)
                }
            }
        }
    }
}
