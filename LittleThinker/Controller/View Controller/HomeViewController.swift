//
//  HomeViewController.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    let db = Firestore.firestore()
    let reuseIdentifier = "cell"
    var myTitle = ["Maths","Science"]
    var myImage = ["undraw_mathematics_4otb","undraw_science_fqhl"]
    var subjectSelected:String = ""
    
    
    var user:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Logout button
        customLogoutButton()
        
        //Set text to current user name
        userName.text = user
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //DEFINE NUMBER OF ROWS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myTitle.count
    }
    
    //POPULATE DATA
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        //Based on itempath.item display different background color
        if indexPath.item == 1 {
            cell.backgroundColor = UIColor(red: 251.0/255.0, green: 176.0/255.0, blue: 59.0/255.0, alpha: 1)
            cell.myTitle.text = myTitle[indexPath.item]
            cell.myImage.image = UIImage(named: myImage[indexPath.item])
        }else{
            cell.myTitle.text = myTitle[indexPath.item]
            cell.myImage.image = UIImage(named: myImage[indexPath.item])
        }
        
        return cell
    }
    
    //GET SELECTED ROW AND PERFORM SEGUE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        subjectSelected = myTitle[indexPath.item]
        performSegue(withIdentifier: "gameQuestions", sender: self)
    }
    
    
    //IBACTIONS to perform segue
    @IBAction func goToRoomVC(_ sender: Any) {
        
        performSegue(withIdentifier: "roomList", sender: self)
    }
    
    @IBAction func goToReportVC(_ sender: Any) {
        performSegue(withIdentifier: "generateReport", sender: self)
    }
    
    
    
    //PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "roomList" {
            _ = segue.destination as! RoomViewController
        }
        
        if segue.identifier == "gameQuestions" {
            let vc = segue.destination as! QuestionsViewController
            vc.subjectName = self.subjectSelected
        }
        
        if segue.identifier == "generateReport" {
            
            _ = segue.destination as! GenerateReportViewController
        }
        
    }
    
}
