//
//  RoomViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 06/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var roomCollectionView: UICollectionView!

    let reuseIdentifier = "roomCell"

    
    
    var teacherArray = [String]()
    var subjectArray = [String]()
    var subjectTitleArray = [String]()
    var studentCountArray = [String]()
    var roomIds = [String]()
    
    
    var clickedRoomId:String = ""
    var students = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton()
        
        let db = Firestore.firestore()
        
        
        let roomCollection = db.collection("Room")
        
        
        //Add a snapshot listener on roomCollection
        roomCollection.addSnapshotListener { (querySnapshot, error) in
            
            
            //Validate erroor
            guard let queryDocument = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            //Declare variables for collectionviewcell data
            self.teacherArray = []
            self.subjectArray = []
            self.subjectTitleArray = []
            self.studentCountArray = []
            self.roomIds = []
            
            //loop through entire document query
            for document in queryDocument.documents {
                
                //Get the fields
                let teacherName = document.get("teacherName") as! String
                let subjectName = document.get("subjectName") as! String
                let title = document.get("title") as! String
                
                
                //Check if student field is empty
                if document.get("student") != nil {
                    
                    //If its not empty get the data and append into a multidimentional dictionary
                    self.students = document.get("student") as! [String : Any]
                    
                    //Count the numbers of stuents inside studenr variable
                    self.studentCountArray.append(String(self.students.count))
                }else{
                    
                    //Else append to empty
                    self.studentCountArray.append("0")
                }
                
                //Append all the values into global variable
                self.teacherArray.append(teacherName)
                self.subjectArray.append(subjectName)
                self.subjectTitleArray.append(title)
                self.roomIds.append(String(document.documentID))
                
            }
            
            //Reload data on every snapshot
            self.roomCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Define number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teacherArray.count
    }
    
    
    //Populate data to collectionviewcell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        //Check if the fields are empty
        if !checkEmpty() {
            cell.teacherName.text = teacherArray[indexPath.item]
            cell.subjectName.text = subjectArray[indexPath.item]
            cell.titleName.text = subjectTitleArray[indexPath.item]
            cell.studentNo.text = studentCountArray[indexPath.item]
        }
        
        //return collectionviewcell
        return cell
    }
    
    
    @IBAction func newRoom(_ sender: Any) {
        performSegue(withIdentifier: "newRoom", sender: self)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Get the indexpath id and set to clickedRoomId
        clickedRoomId = roomIds[indexPath.item]
        performSegue(withIdentifier: "roomDetail", sender: self)
    
    }
    
    //Prepare segue to open controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newRoom" {
            let _ = segue.destination as! AddRoomViewController
        }
        
        if segue.identifier == "roomDetail" {
            let vc = segue.destination as! RoomDetailViewController
            vc.roomId = self.clickedRoomId
        }
        
    }
    
    
    //Function to validate fields
    func checkEmpty() -> Bool {
        
        if teacherArray.count <= 0 || subjectArray.count <= 0 || subjectTitleArray.count <= 0 || studentCountArray.count <= 0  || roomIds.count <= 0 || students.count <= 0 {
            return true
        }else{
            return false
        }
    }
}
