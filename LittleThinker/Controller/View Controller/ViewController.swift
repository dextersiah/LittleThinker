//
//  ViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 04/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    

    @IBOutlet weak var emailField: TextFieldRoudedBorder!
    @IBOutlet weak var passwordField: TextFieldRoudedBorder!
    @IBOutlet weak var errorMessage: UILabel!
    
    var userName:String = ""
    
    //Firebase Declaration
    let db = Firestore.firestore()
    let authenetication = Auth.auth()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Hide Keyboard on outside tap
        self.hideKeyboard()
        
        //Special Hide Navigation Bar For First View controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signIn(_ sender: Any) {
        
        errorMessage.text = ""
        
        if emailField.text == "" || passwordField.text == ""{
            errorMessage.text = "All Fields Are Required"
        }else{
            
            let email = emailField.text!
            let password = passwordField.text!
            
            
            //TODO:: GET USER FROM FIREBASE THROUGH EMAIL AND PASSWORD
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    self.errorMessage.text = error!.localizedDescription
                }else{
                    
                    let currentUser = Auth.auth().currentUser
                    
                    if currentUser != nil {
                        let userId = currentUser!.uid
                        print(userId)
                        self.db.collection("User").whereField("uid", isEqualTo: userId).getDocuments { (querySnapshot, error) in
                            
                            
                            for document in querySnapshot!.documents {
                                let name = document.get("name") as! String
                                self.userName = name

                            }
                        }
                    }
                    
                    
                    self.performSegue(withIdentifier: "homePage", sender: self)
                }
            }

            
            
            
            //CLEAR INPUT AFTER LOGIN
            emailField.text = ""
            passwordField.text = ""
            

        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homePage" {
            let vc = segue.destination as! HomeViewController
            vc.user = userName
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
    
    
    
    @objc func back(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func logout(sender: UIBarButtonItem){
        let authentication = Auth.auth()
        do {
            try authentication.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

         self.navigationController?.popViewController(animated: true)
    }
    
    
    func hideKeyboard(){
        let tap : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
