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
    
    var roomId = ""
    var selectedStudent = ""
    var studentArray = [String]()
    var studentDict = [String:String]()
    
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Border Color for cancel button
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        
        studentDropDown.arrowColor = UIColor.black
        studentDropDown.optionArray = studentArray
       
        
        studentDropDown.didSelect{(selectedText,index,id) in
            self.selectedStudent = selectedText
        }
    
    }
    
    @IBAction func startGameClick(_ sender: Any) {
        db.collection("currentGame").getDocuments { (querySnapshot, error) in
            
            guard let document = querySnapshot else {
                print(error!.localizedDescription)
                return
            }
            
            if document.count <= 0 {
                if self.selectedStudent == "" {
                    ProgressHUD.showError("Please Select A Student")
                }else{
                    self.db.collection("currentGame").addDocument(data: ["roomId" : self.roomId,"student":self.selectedStudent])
                    ProgressHUD.showSuccess("Game Is Starting Soon")
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                ProgressHUD.showError("Game is currently in progress")
            }
        }
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
