//
//  SignUpViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: TextFieldRoudedBorder!
    @IBOutlet weak var usernameText: TextFieldRoudedBorder!
    @IBOutlet weak var passwordText: TextFieldRoudedBorder!
    @IBOutlet weak var confirmPasswordText: TextFieldRoudedBorder!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Back Button With UIImage
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
    
    @IBAction func signUp(_ sender: Any) {
        errorMessage.text = ""
        
        if emailText.text == "" || usernameText.text == "" || passwordText.text == "" || confirmPasswordText.text == "" {
            errorMessage.text = "All Fields Are Required"
        }else{
            //TODO:: ADD USER TO FIREBASE AUTHENTICATION AND USERNAME TO FIREBASE WITH REFERENCE ID
            
            
            errorMessage.text = "Sucessfully Created Account"
        }
    }
    
}



