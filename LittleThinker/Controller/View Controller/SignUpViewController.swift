//
//  SignUpViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import ProgressHUD


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
            ProgressHUD.showError("All fields are required")
        }else{
            
            if passwordText.text != confirmPasswordText.text {
                 ProgressHUD.showError("Password Does Not Match")
            }else{
                
                let name = usernameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                ProgressHUD.show()
                
                //TODO:: ADD USER TO FIREBASE AUTHENTICATION AND USERNAME TO FIREBASE WITH REFERENCE ID
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                       ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        let db = Firestore.firestore()
                        
                        
                        db.collection("User").addDocument(data: ["name":name.capitalized,"uid":result!.user.uid], completion: { (error) in
                            if error != nil {
                                ProgressHUD.showError(error?.localizedDescription)
                            }else{
                                
                                ProgressHUD.dismiss()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    ProgressHUD.showSuccess("Successfully Created Account")
                                })
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                               
                            }
                        })
                    }
                }
            }

            
            
        }
    }
    
}



