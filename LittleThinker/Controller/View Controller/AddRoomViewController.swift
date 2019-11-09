//
//  AddRoomViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 07/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

class AddRoomViewController: UIViewController {

    
    @IBOutlet weak var subjectSelection: DropDown!
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    var subjects = [String]()
    
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
        
        
        
        
        
        //Drop Down Library
        subjectSelection.arrowColor = .white
        
        //TODO:: PULL DATA FROM FIREBASE AND ADD TO subjects VARIABLE 
        subjectSelection.optionArray = ["Maths","Science","English"]
        subjectSelection.optionIds = [1,2,3]
        
        subjectSelection.didSelect{(selectedText,index,id) in
            print(selectedText)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmCreateRoom(_ sender: Any) {
        
        //TODO:: ADD ROOM TO FIREBASE
        print("create room")
        
        
        //TODO:: ON DISMISS IT SHOULD REUPDATE ROOM 
        dismiss(animated: true, completion: nil)
    }
    
    

}
