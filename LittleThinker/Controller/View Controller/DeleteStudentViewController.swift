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
    
    let db = Firestore.firestore()
    
     //TODO:: USE THIS AS REFERENCE TO WHICH STUDENT TO DELETE
    var deletedStudentId:String = ""
    var roomId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameLabel.text = "Remove "+deletedStudentId
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeStudent(_ sender: Any) {
        //TODO:: DATA DATA TO FIREBASE
        ProgressHUD.show()
        db.collection("Room").document(roomId).updateData(["student.\(deletedStudentId)" : FieldValue.delete()]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)

            }
        }
        
    
        
        
        
    }
    
    @IBAction func cancelDelete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
