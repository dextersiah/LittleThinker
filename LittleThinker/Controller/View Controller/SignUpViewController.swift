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
    
    //Go Back To Previous Controller
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
 
    //IBACTION for signUpButton
    @IBAction func signUp(_ sender: Any) {
        
        
        //Validate fields
        if emailText.text == "" || usernameText.text == "" || passwordText.text == "" || confirmPasswordText.text == "" {
            
            //Display HUD error message
            ProgressHUD.showError("All fields are required")
        }else{
            
            //Validate if password & confirm password is same
            if passwordText.text != confirmPasswordText.text {
                 ProgressHUD.showError("Password Does Not Match")
            }else{
                
                //Get textfield value and trim white spaces
                let name = usernameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                //Display HUD loading
                ProgressHUD.show()
                
                //Create an account on firebase authentication with email & password
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                    
                        //Display error on HUD if any
                        ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        
                        //Initialize DB
                        let db = Firestore.firestore()
                
                        //Create a document reference on User collection to hold user name
                        db.collection("User").addDocument(data: ["name":name.capitalized,"uid":result!.user.uid], completion: { (error) in
                            if error != nil {
                                
                                //Display error on HUD if any
                                ProgressHUD.showError(error?.localizedDescription)
                                
                            }else{
                            
                                //Dismiss HUD
                                ProgressHUD.dismiss()
                                
                                
                                /*
                                 Author: Dexter
                                 Desc: Delay Function Before Proceeding With Next Code
                                 Ref: https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
                                 */
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    ProgressHUD.showSuccess("Successfully Created Account")
                                })
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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



