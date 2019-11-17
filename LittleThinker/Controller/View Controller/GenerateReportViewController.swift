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
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Initialize Firebase
    let db = Firestore.firestore()
    
    //Pass Report To ReportDetailController
    var reportDetails:Int = 0
    
    //Global Variable for CollectionViewCell
    var name = [String]()
    var marks = [String]()
    let time = ["1min 2 sec","1min 5 sec","1min 7sec","1min 30sec"]
    
    //Global variable to validate answers
    var correctAnswer = [String]()
    var studentAnswer = [String]()

    
    
    //Array for dropdown roomlist
    var roomList = [String]()
    
    //Global Variable
    var subjectName:String = ""
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportCell", for: indexPath) as! reportCollectionViewCell

        cell.number.text = String(indexPath.item)
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
        
        db.collection("Room").getDocuments { (querySnapshot,error) in
            for doc in querySnapshot!.documents{
                let roomTitle = doc.get("title") as! String
                self.roomLists.optionArray.append(roomTitle)
            }
        }
        
        roomLists.didSelect{(selectedText,index,id) in
            
            //Reinitialize answers
            self.correctAnswer = []
            self.studentAnswer = []
            
            //Set the subject name
            self.subjectName = selectedText
            
            //Proceed only if user has selected a subject
            if self.subjectName != ""{
                
                //Get report based on the roomTitle
                self.db.collection("Report").whereField("roomTitle", isEqualTo: self.subjectName).getDocuments(completion: { (querySnapshot, error) in
                    
                    //Validate Error
                    guard let queryDoc = querySnapshot else{
                        print(error!.localizedDescription)
                        return
                    }
                    
                    //Loop through entire collection
                    for doc in queryDoc.documents{
                        
                        //Get the documentId and fields
                        let docId = doc.documentID
                        let subjName = doc.get("subjectName") as! String
                        
                        self.getStudentAnswer(id: docId, completion: {
                            
                            self.getCorrectAnswer(subjName: subjName, completion: {
                                
                                let incorrectNumber = self.compareDifference(correctAnswer: self.correctAnswer, studentAnswer: self.studentAnswer)
                                self.marks.append(incorrectNumber)
                                self.collectionView.reloadData()
                            })
                        })
                    }
                })
            }

        }
        
    }
    
    func getStudentAnswer(id:String, completion:@escaping() -> Void){
        
        //Get subcollection document of Student_Answer using the document iD
        self.db.collection("Report").document(id).collection("Student_Answer").getDocuments(completion: { (querySnapshot, error) in
            
            //Validate error
            guard let answerQuery = querySnapshot else{
                print(error!.localizedDescription)
                return
            }
            
            for doc in answerQuery.documents{
                //The the answers dictionary
                let answersDict = doc.get("answers") as! [String:String]
                
                
                let studentName = doc.get("studentName") as! String
                
                //Append the student name to global variable name
                self.name.append(studentName)
                
                //Sort the dictionary by key
                let sortedAns = answersDict.sorted(by: {$0.key < $1.key})
                
                //Loop through sorted dictionary and append to global variable
                for value in sortedAns{
                    self.studentAnswer.append(value.value)
                }
            }
            completion()
        })
    }
    
    
    func getCorrectAnswer(subjName:String, completion: @escaping()->Void){
        self.db.collection("Subject").whereField("name", isEqualTo: subjName).getDocuments(completion: { (querySnapshot, error) in
            guard let answerQuery = querySnapshot else{
                print(error!.localizedDescription)
                return
            }
            
            for doc in answerQuery.documents{
                self.db.collection("Subject").document(doc.documentID).collection("Question").getDocuments(completion: { (querySnapshot, error) in
                    guard let answerQuery = querySnapshot else{
                        print(error!.localizedDescription)
                        return
                    }
                    
                    for doc in answerQuery.documents{
                        let correctAns = doc.get("correctAnswer") as! String
                        self.correctAnswer.append(correctAns)
                    }
                    completion()
                })
            }
        })
    }
    
    
    func compareDifference(correctAnswer:[String],studentAnswer:[String]) -> String{
        
        var incorrectCounter = 0
        var questionCounter = 0
        
        for (index,correctAns) in correctAnswer.enumerated(){
            for (stdIndex,studentAns) in studentAnswer.enumerated(){
                if index == stdIndex{
                    if correctAns != studentAns{
                        incorrectCounter+=1
                    }
                }
                questionCounter+=1
            }
        }
        return String("\(incorrectCounter)/\(questionCounter)")
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

