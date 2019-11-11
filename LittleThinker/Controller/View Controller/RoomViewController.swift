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
    
    
    //TODO:: PULL DATA FROM FIREBASE USE SNAPSHOT LISTENER FOR REALTIME UPDATE
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
        
        
        roomCollection.addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            self.teacherArray = []
            self.subjectArray = []
            self.subjectTitleArray = []
            self.studentCountArray = []
            self.roomIds = []
            
            
            for document in documents.documents {
                
                let teacherName = document.get("teacherName") as! String
                let subjectName = document.get("subjectName") as! String
                let title = document.get("title") as! String
                
                if document.get("student") != nil {
                    self.students = document.get("student") as! [String : Any]
                    self.studentCountArray.append(String(self.students.count))
                }else{
                    self.studentCountArray.append("0")
                }
                
                
                self.teacherArray.append(teacherName)
                self.subjectArray.append(subjectName)
                self.subjectTitleArray.append(title)

                self.roomIds.append(String(document.documentID))
                
            }
            self.roomCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teacherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        if !checkEmpty() {
            cell.teacherName.text = teacherArray[indexPath.item]
            cell.subjectName.text = subjectArray[indexPath.item]
            cell.titleName.text = subjectTitleArray[indexPath.item]
            cell.studentNo.text = studentCountArray[indexPath.item]
        }
        
        return cell
    }
    
    
    @IBAction func newRoom(_ sender: Any) {
        performSegue(withIdentifier: "newRoom", sender: self)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        clickedRoomId = roomIds[indexPath.item]
        
        print("selected cell \(clickedRoomId)")
        
        
        
        performSegue(withIdentifier: "roomDetail", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newRoom" {
            let _ = segue.destination as! AddRoomViewController
        }
        
        if segue.identifier == "roomDetail" {
            let vc = segue.destination as! RoomDetailViewController
            vc.roomId = self.clickedRoomId
        }
        
    }
    
    func checkEmpty() -> Bool {
        
        if teacherArray.count <= 0 || subjectArray.count <= 0 || subjectTitleArray.count <= 0 || studentCountArray.count <= 0  || roomIds.count <= 0 || students.count <= 0 {
            return true
        }else{
            return false
        }
    }
}
