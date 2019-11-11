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
    @IBOutlet weak var studentName: UITextField!
    
    var roomId:String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Border Color for cancel button
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        
        
        //Adding Bottom Line TextField Style
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: studentName.frame.height - 2, width: studentName.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 0.5).cgColor
        
        studentName.borderStyle = .none
        studentName.layer.addSublayer(bottomLine)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmAddStudent(_ sender: Any) {
        ProgressHUD.show()
        //TODO:: ADD STUDENT TO FIREBASE
        db.collection("Room").document(roomId).setData(["student" : [studentName.text!.capitalized:studentName.text?.capitalized]], merge: true) { (error) in
            if error != nil {
                print("Error adding student data")
            }else{
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
      
    }
    
    
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
