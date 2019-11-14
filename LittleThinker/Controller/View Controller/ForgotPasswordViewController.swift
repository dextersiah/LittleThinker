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
    }
    
    //IBACTIONS
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        errorMessage.text = ""
        
        //Validate Field
        if emailText.text == "" {
            ProgressHUD.showError("Email Field is Required")
        }else{
            
            let email = emailText.text!
            
            //Send password reset link to email
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    
                    //Display Sucess HUD
                    ProgressHUD.showSuccess("A Reset Password Has Been Sent To Your Email")
                }else{
                    //Display Error HUD
                    ProgressHUD.showError(error?.localizedDescription)
                }
            }
        }
    }
}
