//
//  ReportDetailsViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 09/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit


class StudentAnswerCollectionViewCell : reportCollectionViewCell {
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerD: UILabel!
    
    
}

class ReportDetailsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var reportId:Int = 0
    
    //OUTLETS
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var timeCompleted: UILabel!
    @IBOutlet weak var score: UILabel!
    
    
    //TODO:: PULL DATA REPORT FROM FIEBASE
    var name = "Julina"
    var timeDone = "1min 2sec"
    var studentScore = "3/5"
    
    
    //TODO:: PULL QUESTIONS FROM FIREBASE
    let questions = [
        0 : "What is 5 + 10?",
        1 : "What is 10 + 10?",
        2 : "What is 20 - 9?",
        3 : "What is 100 - 4?",
        4 : "What is 200 - 1 +4?"
    ]
    
    //TODO:: PULL ASSOCIATED ANSWER FROM FIREBASE
    let answers = [
        0 : [
            "a": "11",
            "b": "510",
            "c" : "15",
            "d" : "12"
        ],
        
        1: [
            "a" : "10",
            "b" : "11",
            "c" : "1010",
            "d" : "13"
        ],
        
        2 : [
            "a" : "29",
            "b" : "22",
            "c" : "17",
            "d" : "11"
        ],
        
        3 : [
            "a" : "96",
            "b" : "99",
            "c" : "39",
            "d" : "93"
        ],
        
        4 : [
            "a" : "201",
            "b" : "203",
            "c" : "15",
            "d" : "12"
        ],
        ]
    
    //TODO:: PULL CORRECT ANSWER FROM FIREBASE
    let correctAnswer = [
        0 : "c",
        1 : "a",
        2 : "d",
        3 : "a",
        4 : "b"
    ]
    
    //TODO:: PULL STUDENT SELECTED ANSWER FROM FIREBASE
    let studentAnswer = [
        0 : "a",
        1 : "a",
        2 : "c",
        3 : "a",
        4 : "c"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton()
    
        
        studentName.text = "Name: "+name
        timeCompleted.text = "Time: "+timeDone
        score.text = studentScore
        
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
        
        for index in answers {
            if index.key == currentItem {
                
                //Set Answers Question Number
                cell.questionNumber.text = "Question \(currentItem+1)"
                
                
                //Set the Answers
                for item in answers[index.key]! {
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
                
                //Set Students Answer and set color text to red
                for answers in studentAnswer[index.key]!{
                    switch answers {
                    case "a":
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
                
                
                
                //Set Correct Answer and set color text to green
                for answers in correctAnswer[index.key]!{
                    switch answers {
                    case "a":
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
