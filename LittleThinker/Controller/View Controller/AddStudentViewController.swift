//
//  AddStudentViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 08/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class AddStudentViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var studentName: DropDown!
    
    
    
    ///Global Variable to hold data passed from RoomDetailViewController segue
    var roomId:String = ""
    
    //Global variable to hold student array
    var studentArray = [String]()
    
    //Initialize Firebase db
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Border Color for rounded cancel button
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        

        db.collection("Student").getDocuments { (querySnapshot, error) in
            guard let queryDocuments = querySnapshot else {
                print("Error")
                return
            }
            
            for document in queryDocuments.documents{
                let student = document.get("name") as! String
                print(student)
                self.studentArray.append(student)
            }
            
            //Adding Data to DropDown
            self.studentName.optionArray = self.studentArray
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func confirmAddStudent(_ sender: Any) {
        
        //Show HUD loading
        ProgressHUD.show()
        
        //Get a reference to the doucment based on global roomID and set the new data to the database
        db.collection("Room").document(roomId).setData(["student" : [studentName.text!.capitalized:studentName.text?.capitalized]], merge: true) { (error) in
            
            //Validate for error
            if error != nil {
                print("Error adding student data")
            }else{
                
                //Dismiss HUD loading
                ProgressHUD.dismiss()
                
                //Dimiss Modal
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //Dismiss Modal
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
