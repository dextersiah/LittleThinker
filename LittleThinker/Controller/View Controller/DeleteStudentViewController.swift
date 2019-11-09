//
//  DeleteStudentViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 08/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

class DeleteStudentViewController: UIViewController {

     //TODO:: USE THIS AS REFERENCE TO WHICH STUDENT TO DELETE
    var deletedStudentId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeStudent(_ sender: Any) {
        
        
        //TODO:: DATA DATA TO FIREBASE
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelDelete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
