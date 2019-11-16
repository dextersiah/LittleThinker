//
//  GenerateReportViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 09/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase


class reportCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var marks: UILabel!
    @IBOutlet weak var timeCompleted: UILabel!
}

class GenerateReportViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var roomLists: DropDown!
    
    //Initialize Firebase
    let db = Firestore.firestore()
    
    //Pass Report To ReportDetailController
    var reportDetails:Int = 0
    
    //Global Variable for CollectionViewCell
    let number = ["1","2","3","4"]
    let name = ["Brandon","Arthur","Louise","Johan"]
    let marks = ["4/5","4/5","5/5","1/5"]
    let time = ["1min 2 sec","1min 5 sec","1min 7sec","1min 30sec"]
    var roomList = [String]()
    
    //Global Variable
    var subjectName:String = ""
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.number.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportCell", for: indexPath) as! reportCollectionViewCell
        
        cell.number.text = number[indexPath.item]
        cell.studentName.text = name[indexPath.item]
        cell.marks.text = marks[indexPath.item]
        cell.timeCompleted.text = time[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reportDetails = indexPath.item
        
        performSegue(withIdentifier: "reportDetails", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton()
        
        //TODO:: PULL DATA FROM FIREBASE AND ADD TO roomList VARIABLE
        roomLists.optionArray = ["Fun Maths","General Science","Basic English"]
        roomLists.optionIds = [1,2,3]
        
        roomLists.didSelect{(selectedText,index,id) in
            self.subjectName = selectedText
        }
        
        if subjectName != ""{
            db.collection("<#T##collectionPath: String##String#>")
        }
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ReportDetailsViewController
        vc.reportId = self.reportDetails
    }
    
}

