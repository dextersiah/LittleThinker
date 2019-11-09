//
//  ForgotPasswordViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

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
            errorMessage.text = "Email Field is Required"
        }
    }
}
