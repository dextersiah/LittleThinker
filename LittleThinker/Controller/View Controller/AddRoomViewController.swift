//
//  AddRoomViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 07/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD


class AddRoomViewController: UIViewController {

    
    @IBOutlet weak var subjectSelection: DropDown!
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var subjects = [String]()
    var subjectSelected = ""
    var teacherName = ""
    
    let db = Firestore.firestore()
    let currentUserId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Border Color for cancel button
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        
        
        //Adding Bottom Line TextField Style
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: className.frame.height - 2, width: className.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 0.5).cgColor
        
        className.borderStyle = .none
        className.layer.addSublayer(bottomLine)
        
        
        //TODO:: PULL DATA FROM FIREBASE AND ADD TO subjects VARIABLE 
        subjectSelection.optionArray = ["Maths","Science","English"]
        subjectSelection.optionIds = [1,2,3]
        
        subjectSelection.didSelect{(selectedText,index,id) in
            self.subjectSelected = selectedText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmCreateRoom(_ sender: Any) {
        
        if className.text == "" || subjectSelected == "" {
            ProgressHUD.showError("All Fields Are Required")
        }else{
            
            ProgressHUD.show()
            db.collection("User").whereField("uid", isEqualTo: currentUserId!).getDocuments { (querySnapshot, error) in
                for document in querySnapshot!.documents {
                    let name = document.get("name") as! String
                    self.teacherName = name
                    
                    self.db.collection("Room").addDocument(data: ["subjectName" : self.subjectSelected,"title":self.className.text!,"teacherName":self.teacherName]) { (error) in
                        if error != nil {
                            print("Error Creating Room")	
                        }else{
                            ProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                }
            }


        }
    }
    
    

}
