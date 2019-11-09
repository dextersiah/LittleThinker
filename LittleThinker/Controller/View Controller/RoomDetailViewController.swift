//
//  RoomDetailViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 07/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

    protocol myCellDelegate: AnyObject {
        func deletePressed(cell: myCells)
    }


    class myCells : UICollectionViewCell{
        @IBOutlet weak var studentName: UILabel!
        @IBOutlet weak var deleteButton: UIButton!

        weak var delegate: myCellDelegate?
        
        
        @IBAction func deleteClicked(_ sender: Any) {
            delegate?.deletePressed(cell: self)
        }

    }


    class RoomDetailViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,myCellDelegate {

        @IBOutlet weak var collectionView: UICollectionView!
    
        var deleteStudentId:Int = 0
        var roomId:Int = 0
        
         //TODO:: PULL DATA FROM FIREBASE BAED ON roomId USE SNAPSHOT LISTENER FOR REALTIME UPDATE
        var students = ["Brandon","Brenda","Louise","Angela","Arthur"]
        
        

        override func viewDidLoad() {
            super.viewDidLoad()
            customBackButton()
            // Do any additional setup after loading the view.
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.students.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCells
            
            cell.delegate = self
            cell.studentName.text = students[indexPath.item]
            
            return cell
        }
        
        @IBAction func addStudent(_ sender: Any) {
            
            performSegue(withIdentifier: "addStudent", sender: self)
        }
        
        func deletePressed(cell: myCells) {
            
            let indexPath = self.collectionView.indexPath(for: cell)!
            
            deleteStudentId = indexPath.item
            performSegue(withIdentifier: "deleteStudent", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addStudent" {
                _ = segue.destination as! AddStudentViewController
            }
            
            if segue.identifier == "deleteStudent" {
                let vc = segue.destination as! DeleteStudentViewController
                vc.deletedStudentId = self.deleteStudentId
            }
        }
        
        //TODO::START GAME ON IPAD
        @IBAction func startGame(_ sender: Any) {
            
        }
        
    }

    
    

