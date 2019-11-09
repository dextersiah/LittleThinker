//
//  RoomViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 06/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var roomId:Int = 0
    
    //TODO:: PULL DATA FROM FIREBASE USE SNAPSHOT LISTENER FOR REALTIME UPDATE
    let reuseIdentifier = "roomCell"
    var teacher = ["Jackie","Angie","Chee"]
    var subject = ["Maths","Science","English"]
    var subjectTitle = ["Fun Maths","General Science","Basic English"]
    var student = ["5","8","6"]
    
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
        return self.teacher.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        roomId = indexPath.item
        
        cell.teacherName.text = teacher[indexPath.item]
        cell.subjectName.text = subject[indexPath.item]
        cell.titleName.text = subjectTitle[indexPath.item]
        cell.studentNo.text = student[indexPath.item]
        
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
