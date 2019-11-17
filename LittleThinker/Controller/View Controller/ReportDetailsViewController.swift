//
//  ReportDetailsViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 09/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class StudentAnswerCollectionViewCell : reportCollectionViewCell {
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerD: UILabel!
    
    
}

class ReportDetailsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var reportId:String = ""
    var studName:String = ""
    var totalMarks:String = ""
    var subjName:String = ""
    
    //OUTLETS
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var timeCompleted: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var timeDone = "1min 2sec"
    
    
    //TODO:: PULL QUESTIONS FROM FIREBASE
    var questions = [Int:String]()
    var answers = [Int:[String:String]]()
    var correctAnswer = [Int:String]()
    var studentAnswer = [Int:String]()
    var count:Int = 0
    
    //Initialize DB
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton()
        
        // data from GenerateReportController
        studentName.text = "Name: "+studName
        timeCompleted.text = "Time: "+timeDone
        score.text = totalMarks
        
        
        getStudentAnswer {
            ProgressHUD.show()
            
            self.getQuestionAnswer {
                ProgressHUD.dismiss()
                self.collectionView.reloadData()
            }
        }

    }
    
    func getStudentAnswer(completion: @escaping()->Void){
        db.collectionGroup("Student_Answer").whereField("studentName", isEqualTo: studName).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else{
                print(error!.localizedDescription)
                return
            }
            
            for document in querySnapshot.documents{
                let studentAnsDict = document.get("answers") as! [String:String]
                
                let sortedAns = studentAnsDict.sorted(by: {$0.key < $1.key})
                
                
                var counter = 0
                for answers in sortedAns{
                    self.studentAnswer[counter] = answers.value
                    counter+=1
                }
            }
            completion()
        }
    }
    
    func getQuestionAnswer(completion: @escaping()-> Void){
        
        //Get document from subject collection based on name fields
        db.collection("Subject").whereField("name", isEqualTo: self.subjName).getDocuments { (querySnapshot, error) in
            
            //Check if error
            if error != nil {
                print(error!.localizedDescription)
            }
            
            //Loop through the array of documents
            for document in querySnapshot!.documents {
                let documentId = document.documentID
                
                //Based on root document ID, get the subCollection document
                self.db.collection("Subject").document(documentId).collection("Question").getDocuments(completion: { (subQuerySnapshot, error) in
                    
                    //Loop through the array of documents
                    for subDocument in subQuerySnapshot!.documents {
                        
                        //Get the specific fields in document
                        let getQuestion = subDocument.get("question") as! String
                        let getAnswer = subDocument.get("answers") as! [String:String]
                        let getCorrectAnswer = subDocument.get("correctAnswer") as! String
                        
                        //Append Value to global variable with as a dictionary
                        self.questions[self.count] = getQuestion
                        self.answers[self.count] = getAnswer
                        self.correctAnswer[self.count] = getCorrectAnswer
                        self.count+=1
                        
                    }
                    
                    completion()
                })
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "studentAnswers", for: indexPath) as! StudentAnswerCollectionViewCell
        
        //Set Question
        cell.question.text = questions[indexPath.item]

        let currentItem = indexPath.item

        //Loop through multidimentional dictionary
        for index in answers {
            
            //Check the dict.key if equals to current indexPath.item number
            if index.key == currentItem {
                
                //Set Question Number
                cell.questionNumber.text = "Question \(currentItem+1)"
                
                //Loop through the individual
                for item in answers[index.key]! {
                    
                    //Populate the data based on the key
                    switch item.key {
                    case "a":
                        cell.answerA.text = "a. "+item.value
                        
                    case "b":
                        cell.answerB.text = "b. "+item.value
                        
                    case "c":
                        cell.answerC.text = "c. "+item.value
                        
                    case "d":
                        cell.answerD.text = "d. "+item.value
                        
                    default:
                        print("NO VALUE")
                    }
                }
                
                
                for studentAnswer in studentAnswer[index.key]!{
                    switch studentAnswer {
                    case "a":
                        //Set text color to green as idicate correct answer
                        cell.answerA.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                        
                    case "b":
                        cell.answerB.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                        
                    case "c":
                        cell.answerC.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                        
                    case "d":
                        cell.answerD.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                        
                    default:
                        print("NO ANSWER")
                    }
                }
                
                
                //Loop through dictionary answers based on index
                for answers in correctAnswer[index.key]!{
                    switch answers {
                    case "a":
                        //Set text color to green as idicate correct answer
                        cell.answerA.textColor = UIColor(red: 73/255, green: 190/255, blue: 89/255, alpha: 1)

                    case "b":
                        cell.answerB.textColor = UIColor(red: 73/255, green: 190/255, blue: 89/255, alpha: 1)

                    case "c":
                        cell.answerC.textColor = UIColor(red: 73/255, green: 190/255, blue: 89/255, alpha: 1)

                    case "d":
                        cell.answerD.textColor = UIColor(red: 73/255, green: 190/255, blue: 89/255, alpha: 1)

                    default:
                        print("NO ANSWER")
                    }
                }
                
                

                
                
            }
        }
        
        return cell
    }
    
    
}
