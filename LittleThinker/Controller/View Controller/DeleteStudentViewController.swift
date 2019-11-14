//
//  DeleteStudentViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 08/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD


class DeleteStudentViewController: UIViewController {
    @IBOutlet weak var studentNameLabel: UILabel!
    
    //Initialize Firebase db
    let db = Firestore.firestore()
    
    //Global Variable to hold data passed from DetailRoomViewController segue
    var deletedStudentId:String = ""
    var roomId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title with student name
        studentNameLabel.text = "Remove \(deletedStudentId)?"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeStudent(_ sender: Any) {
        //Display HUD loading
        ProgressHUD.show()
        
        //Get a reference to the document based on global roomId and update the map field based on key
        db.collection("Room").document(roomId).updateData(["student.\(deletedStudentId)" : FieldValue.delete()]) { (error) in
            
            //Validate if error
            if error != nil {
                print(error!.localizedDescription)
            }else{
                
                //Dismiss HUD loading
                ProgressHUD.dismiss()
                
                //Dismiss Modal
                self.dismiss(animated: true, completion: nil)

            }
        }
    }
    
    //Dismiss Modal
    @IBAction func cancelDelete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
