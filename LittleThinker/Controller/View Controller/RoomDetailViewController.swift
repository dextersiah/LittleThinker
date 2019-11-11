//
//  RoomDetailViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 07/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase

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
        
        
        let db = Firestore.firestore()
    
        var deleteStudentId:String = ""
        var roomId:String = ""
        var studentsArray = [String]()
        var studentsDict = [String:String]()

        override func viewDidLoad() {
            super.viewDidLoad()
            customBackButton()
            
            //ADD REAL TIME SNAPSHOT LISTENER ON specific room document
            db.collection("Room").document(roomId).addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                self.studentsArray = []
                
                if document.get("student") != nil {
                     self.studentsDict = document.get("student") as! [String:String]
                    
                    for (_,value) in self.studentsDict.enumerated() {
                        self.studentsArray.append(value.value)
                        
                    }
                }
                
                //RELOAD COLLECTION VIEW FOR EVERY UPDATE FROM SNAPSHOT
                self.collectionView.reloadData()
            }

            // Do any additional setup after loading the view.
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //COLLECTION VIEW SETUP
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.studentsArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCells
            
            cell.delegate = self
            cell.studentName.text = studentsArray[indexPath.item]
            
            return cell
        }
        
        
        //IB ACTIONS
        @IBAction func addStudent(_ sender: Any) {
            
            performSegue(withIdentifier: "addStudent", sender: self)
        }
        
        //TODO::START GAME ON IPAD
        @IBAction func startGame(_ sender: Any) {
            performSegue(withIdentifier: "startGame", sender: self)
        }
        
        func deletePressed(cell: myCells) {
            
            let indexPath = self.collectionView.indexPath(for: cell)!
            
            deleteStudentId = studentsArray[indexPath.item]
            performSegue(withIdentifier: "deleteStudent", sender: self)
        }
        
        
        //PREPARE FOR SEGUE
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

    
    

