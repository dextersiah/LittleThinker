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
    
    var roomId:String = ""
    @IBOutlet weak var roomCollectionView: UICollectionView!
    
    
    //TODO:: PULL DATA FROM FIREBASE USE SNAPSHOT LISTENER FOR REALTIME UPDATE
    let reuseIdentifier = "roomCell"
    var teacherArray = [String]()
    var subjectArray = [String]()
    var subjectTitleArray = [String]()
    var studentCountArray = [String]()

    
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
            
            for document in documents.documents {
                
                
                
                let teacherName = document.get("teacherName") as! String
                let subjectName = document.get("subjectName") as! String
                let title = document.get("title") as! String
                let students = document.get("student") as! [String : Any]
                
                
                self.teacherArray.append(teacherName)
                self.subjectArray.append(subjectName)
                self.subjectTitleArray.append(title)
                self.studentCountArray.append(String(students.count))
                
                
            }
            
            print(self.teacherArray)
            print(self.subjectArray)
            print(self.subjectTitleArray)
            print(self.studentCountArray)
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
        
        roomId = String(indexPath.item)
        
        cell.teacherName.text = teacherArray[indexPath.item]
        cell.subjectName.text = subjectArray[indexPath.item]
        cell.titleName.text = subjectTitleArray[indexPath.item]
        cell.studentNo.text = studentCountArray[indexPath.item]
        
        return cell
    }
    
    
    @IBAction func newRoom(_ sender: Any) {
        performSegue(withIdentifier: "newRoom", sender: self)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell \(indexPath.item)")
        
        performSegue(withIdentifier: "roomDetail", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newRoom" {
            let _ = segue.destination as! AddRoomViewController
        }
        
        if segue.identifier == "roomDetail" {
            let vc = segue.destination as! RoomDetailViewController
            vc.roomId = self.roomId
        }
        
    }
}
