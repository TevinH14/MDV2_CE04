//
//  StatusViewController.swift
//  HamiltonTevin_CE04
//
//  Created by Tevin Hamilton on 10/22/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//

import UIKit
import CoreData

class StatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //array of UserData from coreData
    var userDataArray = [UserData]()
    // used to connect to the coredata delegate in appDelegate
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //used to reach the contect of the coredata
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call loadData() method
        loadData()
    }
    //MARK:Load CoreData
    //load CoreData Entity UserScores and turn the retri
    func loadData() {
        var numTurns:Int = 0
        var timeCom:Int = 0
        let data = NSFetchRequest<NSFetchRequestResult>(entityName: "UserScores")
        do {
            // We will receive an array of Tap values
            if let userScoreArray = try context.fetch(data) as? [UserScores] {
                
                // lets test to see what has been saved
                for users in userScoreArray { 
                    print(users.timeCompletion)
                    print(users.userName!)
                    print(users.date!)
                    
                    //convert to int
                    let numberOfTurns: Int16 = users.numberOfTurns
                    numTurns = Int(numberOfTurns)
                    let timeCompletion: Int16 = users.timeCompletion
                    timeCom = Int(timeCompletion)
                    
                    //add to userdataArray and pass data to userData object
                    userDataArray.append( UserData(userName: users.userName!, dataStamp: users.date!, moveCount: numTurns, timeCompletion: timeCom))
                }
            }
            print("Fetching data worked")
        }
        catch {
            print("Fetching data Failed", error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //sort userData Array using timeCompletion
        userDataArray = userDataArray.sorted(by: { $0.timeCompletion < $1.timeCompletion })
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Id1", for: indexPath)
        
        cell.textLabel?.text = userDataArray[indexPath.row].userName
        let minutes = userDataArray[indexPath.row].timeCompletion / 60
        let seconds = userDataArray[indexPath.row].timeCompletion % 60
        let moves = userDataArray[indexPath.row].moveCount
        let date = userDataArray[indexPath.row].dateStamp
        
        cell.detailTextLabel?.text = "Time:\(minutes.description):\(seconds.description), MOVES:\(moves.description), Date:\(date)"
        
        return cell
        
    }
}
