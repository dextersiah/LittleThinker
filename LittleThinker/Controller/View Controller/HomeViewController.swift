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
    var myTitle = ["Science","Maths"]
    var myImage = ["undraw_science_fqhl","undraw_mathematics_4otb"]
    var row : Int = 0
    var user:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLogoutButton()
        
        userName.text = user
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DEFINE NUMBER OF ROWS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myTitle.count
    }
    
    //POPULATE DATA
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.16
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
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
        print("selected at index \(indexPath.item)")
        row = indexPath.item
        performSegue(withIdentifier: "gameQuestions", sender: self)
    }
    
    
    //IBACTIONS
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
            vc.id = self.row
        }
        
        if segue.identifier == "generateReport" {
            
            _ = segue.destination as! GenerateReportViewController
        }
        
    }
    
}
