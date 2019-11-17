//
//  QuestionsViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 08/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class QuestionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subjectTitle: UILabel!
    
    //Initialize Firebase DB
    let db = Firestore.firestore()
    
    //Variable For Passing subjectName from homeView segue
    var subjectName:String = ""
    
    //Declare Variables for collection view cell
    var questions = [Int:String]()
    var answers = [Int:[String:String]]()
    var correctAnswer = [Int:String]()
    var count:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Back Button
        customBackButton()

        //Get document from subject collection based on name fields
        db.collection("Subject").whereField("name", isEqualTo: subjectName).getDocuments { (querySnapshot, error) in
            ProgressHUD.show()
            //Check if error
            if error != nil {
                print(error!.localizedDescription)
            }

            //Loop through the array of documents
            for document in querySnapshot!.documents {
                let documentId = document.documentID
                let subjectTitle = document.get("name") as! String 
                self.subjectTitle.text = subjectTitle
                
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
                    
                    //Reload collection view after querySnapshot ends
                    self.collectionView.reloadData()
                    ProgressHUD.dismiss()
                })
            }
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Define number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    //Populate the data in individual collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Initialize a cell based on QuestionCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! QuestionCollectionViewCell
        
        //Set Question
        cell.questionTitle.text = questions[indexPath.item]
        
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
