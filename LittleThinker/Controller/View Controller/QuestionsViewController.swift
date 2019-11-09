//
//  QuestionsViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 08/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    //TODO:: USE THIS TO CHECK DATA FROM FIREBASE
    var id:Int = 0

    //TODO:: PULL DATA FROM FIREBASE
    let questions = [
        0 : "What is 5 + 10?",
        1 : "What is 10 + 10?",
        2 : "What is 20 - 9?",
        3 : "What is 100 - 4?",
        4 : "What is 200 - 1 +4?"
    ]
    
    //TODO:: PULL DATA FROM FIREBASE
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
    
    //TODO:: PULL DATA FROM FIREBASE
    let correctAnswer = [
            0 : "c",
            1 : "a",
            2 : "d",
            3 : "a",
            4 : "b"
        ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton()
        print(id)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! QuestionCollectionViewCell
        
        cell.questionTitle.text = questions[indexPath.item]
        
        let currentItem = indexPath.item
        
        for index in answers {
            if index.key == currentItem {
                cell.questionNumber.text = "Question \(currentItem+1)"
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
