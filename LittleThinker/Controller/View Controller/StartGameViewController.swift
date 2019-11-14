//
//  StartGameViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 11/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class StartGameViewController: UIViewController {
    
    
    @IBOutlet weak var studentDropDown: DropDown!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    //Global Variable to hold data passed from DetailRoomViewController segue
    var roomId = ""
    var selectedStudent = ""
    var studentArray = [String]()
    
    
    //Initialize Firebase db
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Border Color for rounded cancel button
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        
        //Define the options in dropdown
        studentDropDown.optionArray = studentArray
       
        //Get the text of selected value from dropdown
        studentDropDown.didSelect{(selectedText,index,id) in
            self.selectedStudent = selectedText
        }
    
    }
    
    @IBAction func startGameClick(_ sender: Any) {
        
        //Get documents from currentGame collection
        db.collection("currentGame").getDocuments { (querySnapshot, error) in
            
            //Validate for error
            guard let document = querySnapshot else {
                print(error!.localizedDescription)
                return
            }
            
            //Check if there is a current player playing in progress
            if document.count <= 0 {
                
                //Check if there is a selected student from dropdown
                if self.selectedStudent == "" {
                    ProgressHUD.showError("Please Select A Student")
                    
                //Set a new document in currentGame collection with roomId and studentname
                }else{
                    self.db.collection("currentGame").addDocument(data: ["roomId" : self.roomId,"student":self.selectedStudent])
                    
                    //Display Game is Starting on HUD
                    ProgressHUD.showSuccess("Game Is Starting Soon")
                    
                    //Dismiss Modal
                    self.dismiss(animated: true, completion: nil)
                }
                
            //Display error HUD
            }else{
                ProgressHUD.showError("Game is currently in progress")
            }
        }
    }
    
    //Dismiss Modal
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
