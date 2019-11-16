//
//  ViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 04/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase
import ProgressHUD


class ViewController: UIViewController {
    

    @IBOutlet weak var emailField: TextFieldRoudedBorder!
    @IBOutlet weak var passwordField: TextFieldRoudedBorder!
    @IBOutlet weak var errorMessage: UILabel!
    
    var userName:String = ""
    
    //Firebase Declaration
    lazy var db = Firestore.firestore()
    lazy var authenetication = Auth.auth()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.hudColor(UIColor.black)
        
        //Hide Keyboard on outside tap
        self.hideKeyboard()
        
        //Special Hide Navigation Bar For First View controller
        clearNavigationBar()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signIn(_ sender: Any) {
        
        
        if emailField.text == "" || passwordField.text == ""{
            ProgressHUD.showError("All Fields Are Required")
        }else{
            
            //Show HUD
            ProgressHUD.show()
            let email = emailField.text!
            let password = passwordField.text!
            
            
            //Sign in user using email passsword
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                //Validate error
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                }else{
                    
                    //Get current user
                    let currentUser = Auth.auth().currentUser
                    
                    if currentUser != nil {
                        
                        //Get current user id
                        let userId = currentUser!.uid
                        
                        //Get user details from User collection
                        self.db.collection("User").whereField("uid", isEqualTo: userId).getDocuments { (querySnapshot, error) in
                            
                            
                            for document in querySnapshot!.documents {
                                
                                //Get the user name
                                let name = document.get("name") as! String
                                
                                //Set the name to global variable
                                self.userName = name
                                
                                //Dimiss HUD
                                ProgressHUD.dismiss()
                                self.performSegue(withIdentifier: "homePage", sender: self)
                                
                                //CLEAR INPUT AFTER LOGIN
                                self.emailField.text = ""
                                self.passwordField.text = ""
                            }
                        }
                    }
                }

            }
        }
    }
    
    //IBaction to perform segue to next controller
    @IBAction func forgotPassword(_ sender: Any) {
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    //Prepare segue to open next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homePage" {
            let vc = segue.destination as! HomeViewController
            vc.user = self.userName
        }
        
        if segue.identifier == "forgotPassword" {
            _ = segue.destination as! ForgotPasswordViewController
        }
        
        if segue.identifier == "signUp" {
            _ = segue.destination as! SignUpViewController
        }
    }
    
}

//EXTENSION OF VIEWCONTROLLER FOR CUSTOM BAR BUTTON ITEM
extension UIViewController{
    func customBackButton (){
        
        //Set custom back button with image and set the action to back
        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "Backward arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        backButton.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        //Make it opaque
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    //Set navigation bar to be opaque without any navigation items
    func clearNavigationBar () {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func customLogoutButton (){
        
        //Set custom back button with image and set the action to back
        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "Export").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        backButton.addTarget(self, action: #selector(self.logout(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        //Make it opaque
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    //function to go back to previous opened controller
    @objc func back(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //function to logout
    @objc func logout(sender: UIBarButtonItem){
        let authentication = Auth.auth()
        do {
            try authentication.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

         self.navigationController?.popViewController(animated: true)
    }
    
    //function to hide keyboard when tap outside of keyboard
    func hideKeyboard(){
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
