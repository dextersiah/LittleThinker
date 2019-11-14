//
//  RoomDetailViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 07/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase


    /*
        Author: Dexter
        Desc: delegate to pass data from classes
        Ref: https://stackoverflow.com/questions/39585638/get-indexpath-of-uitableviewcell-on-click-of-button-from-cell
             https://stackoverflow.com/questions/58755467/getting-indexpath-of-collectionviewcell-on-button-touch/58755518?noredirect=1#comment103808465_58755518
    */

    protocol myCellDelegate: AnyObject {
        func deletePressed(cell: myCells)
    }

    //Create a class to hold the collectionviewcell and delegate
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
        
        //Initialize Firebase db
        let db = Firestore.firestore()
        
        //Global Variable to hold data passed to DeleteStudentViewController segue
        var deleteStudentId:String = ""
        
        //Global Variable to hold data passed from RoomViewController segue
        var roomId:String = ""
        
        //Iniitalize variable for collection view data
        var studentsArray = [String]()
        var studentsDict = [String:String]()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            //Custom Back Button
            customBackButton()
            
            //Get document from Room collection based on global roomId
            db.collection("Room").document(roomId).addSnapshotListener { (documentSnapshot, error) in
                
                //Validate if error
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                //Reinitialize array to be empty to prevent duplicate data
                self.studentsArray = []
                
                //Check if student vield exists
                if document.get("student") != nil {
                     self.studentsDict = document.get("student") as! [String:String]
                    
                    //loop through dictionary
                    for (_,value) in self.studentsDict.enumerated() {
                        
                        //Appending studentname from document field to studentArray
                        self.studentsArray.append(value.value)
                        
                    }
                }
                
                //Reload Collection View for every snapshot
                self.collectionView.reloadData()
            }
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //Define number of item in section
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.studentsArray.count
        }
        
        
        //Popoulate data into collectionViewCell
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            
            //Initialize a cell based on custom UICollectionViewCell (myCells)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCells
            
            //Set the delegate to current method
            cell.delegate = self
            
            //Set the studentName based on studentArray
            cell.studentName.text = studentsArray[indexPath.item]
            
            //Return collectionviewcell
            return cell
        }
        
        
        //IBactions
        @IBAction func addStudent(_ sender: Any) {
            
            performSegue(withIdentifier: "addStudent", sender: self)
        }
        
        @IBAction func startGame(_ sender: Any) {
            performSegue(withIdentifier: "startGame", sender: self)
        }
        
        
        func deletePressed(cell: myCells) {
            
            //Get the indexpath from the delegate
            let indexPath = self.collectionView.indexPath(for: cell)!
        
            //Append the studentId to based selected button
            deleteStudentId = studentsArray[indexPath.item]
            
            
            performSegue(withIdentifier: "deleteStudent", sender: self)
        }
        
        

        /*
         Author: Dexter
         Desc: Perform a segue to open controller and pass data
         Ref: https://www.youtube.com/watch?v=uKQjJb-KSwU
         */
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addStudent" {
                let vc = segue.destination as! AddStudentViewController
                vc.roomId = self.roomId
            }
            
            if segue.identifier == "deleteStudent" {
                let vc = segue.destination as! DeleteStudentViewController
                vc.deletedStudentId = self.deleteStudentId
                vc.roomId = self.roomId
            }
            
            if segue.identifier == "startGame" {
                let vc = segue.destination as! StartGameViewController
                vc.roomId = self.roomId
                vc.studentArray = self.studentsArray
            }
        }
        
    }

    
    

