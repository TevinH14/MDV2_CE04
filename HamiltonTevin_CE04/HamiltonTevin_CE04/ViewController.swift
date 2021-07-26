//
//  ViewController.swift
//  HamiltonTevin_CE04
//
//  Created by Tevin Hamilton on 10/9/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//

import UIKit
import CoreData
//UIView.transitionFromView(fromView, toView: toView, duration: 1, options: .TransitionFlipFromRight, completion: nil)
class ViewController: UIViewController,UIImagePickerControllerDelegate {
    //need for coreData
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: varibles, arrays and timer
    var sec = 6
    var timer = Timer()
    var imageArray = [UIImage]()
    var ipadIndexArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
    var iphoneindexArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    var shuffledArray = [UIImage]()
    var newIndexArray = [Int]()
    var firstPick:Int?
    var secPick:Int?
    var tapsCheck:Int = 0
    var buttonCheck = true
    var winCounter = 0
    var movesCount = 0
    var userName = ""
    var dateString = ""
    
    //MARK:IBOutlet
    @IBOutlet weak var LabelSec: UILabel!
    @IBOutlet var ImageCollection: [UIImageView]!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var winnerInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //counter used to help loop throw images in assets
        var counter = 1
        
        //check if current device is ipad
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            //shuffle ipadindex array to newindexArray for images.
            newIndexArray = ipadIndexArray.shuffled()
            
            //loop until imageArray hold 30 images
            while imageArray.count != 30
            {
                imageArray.append(UIImage(named: "image\(String(counter))")!)
                imageArray.append(UIImage(named: "image\(String(counter))")!)
                
                counter += 1
            }
            //suffle images
            shuffledArray = imageArray.shuffled()
            
            counter = 0
            // loop until index reaches 29
            for index in 0...29
            {
                //set up tap gestureRecongnizer
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.cellTappedMethod(_:)))
                singleTap.delegate = self as? UIGestureRecognizerDelegate
                //add tap gesture to UiImageView in the imagecollection
                ImageCollection[index].addGestureRecognizer(singleTap)
                //turn on interaction
                ImageCollection[index].isUserInteractionEnabled = true
                
                counter += 1
            }
        }
        else
        {
             //shuffle iphoneindex array to newindexArray for images.
            iphoneindexArray = iphoneindexArray.shuffled()
            while imageArray.count != 20
            {
                
                imageArray.append(UIImage(named: "image\(String(counter))")!)
                imageArray.append(UIImage(named: "image\(String(counter))")!)
                counter += 1
            }
            
            shuffledArray = imageArray.shuffled()
            counter = 0
            // loop to 19
            for index in 0...19
            {
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.cellTappedMethod(_:)))
                singleTap.delegate = self as? UIGestureRecognizerDelegate
                ImageCollection[index].addGestureRecognizer(singleTap)
                ImageCollection[index].isUserInteractionEnabled = true
                counter += 1
            }
        }
    }
    
    //MARK: ImageView Taps
    @objc func cellTappedMethod(_ sender:AnyObject)
    {
        //get tag number
        let tagNumber = sender.view.tag
        //get image with the same index number in shuffledArray to current imageview in imageCollection
        ImageCollection[tagNumber].image = shuffledArray[sender.view.tag]
        //check if first pick is nil
        if firstPick == nil
        {
            //cpature users first tap
            firstPick = sender.view.tag
            //add one to tapsCheck
            tapsCheck += 1
        }
            
        //see if first pick is no longer nil
        else if firstPick != nil
        {
            //get tag for secPick
            secPick = sender.view.tag
            tapsCheck += 1
        }
        //check if firstpick and secPick is not nill nad tapscheck is same as 2
        if firstPick != nil && secPick != nil && tapsCheck == 2
        {
            //loop through imagecollection
            for imageView in self.ImageCollection
            {
                //turn off userInteraction
                imageView.isUserInteractionEnabled = false
            }
            //delay the condtionals below
            let secondsToDelay = 0.15
            
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                //check if firstpick image is the same as secPick image
                if self.shuffledArray[self.firstPick!].isEqual(self.shuffledArray[self.secPick!])
                {
                    //hide matching imageView and disable the user interaction
                    self.ImageCollection[self.firstPick!].isHidden = true
                    self.ImageCollection[self.secPick!].isHidden = true
                    self.ImageCollection[self.firstPick!].isUserInteractionEnabled = false
                    self.ImageCollection[self.secPick!].isUserInteractionEnabled = false
                    self.CheckWinningStatus()
                    //add one to user moves count
                    self.movesCount += 1
                    
                }
                else
                {
                    //remove the movie
                    self.ImageCollection[self.firstPick!].image = nil
                    self.ImageCollection[self.secPick!].image = nil
                    
                }
                //enabled all user interaction for remain images.
                for imageView in self.ImageCollection
                {
                    imageView.isUserInteractionEnabled = true
                }
                //set firstpick and secPick to nill
                self.firstPick = nil
                self.secPick = nil
            }
            tapsCheck = 0
        }
        // add one to moves count
        self.movesCount += 1
    }
    
    //MARK:Start and Stop Function
    @IBAction func StartandStopFunction(_ sender: UIButton?)
    {
        //check if StartandStop button text equal to stop
        if (startAndStopButton.titleLabel?.text == "Stop")
        {
            //stop timer
            timer.invalidate()
            
            //reshuffle suffled array
            shuffledArray =  shuffledArray.shuffled()
            
            //change button text to Start
            startAndStopButton.titleLabel?.text = "Start"
            
            //add 6 to sec
            sec = 6
            
            //hide imageViews in imagecolloection
            for imageView in ImageCollection
            {
                imageView.isHidden = false
            }
        }
        //if button text is the same as Start
        else
        {
            var counter = 0
            
            winnerInfo.isHidden = true
            cardContainer.isHidden = false
            movesCount = 0
            
            //check if iphone
            if UIDevice.current.userInterfaceIdiom == .phone
            {
                //loop until index  reaches 19
                for index in 0...19
                {
                    ImageCollection[index].isUserInteractionEnabled = false
                    ImageCollection[counter].image = shuffledArray[counter]
                    ImageCollection[index].isHidden = false
                    counter += 1
                    sec = 6
                }
            }
            else
            {
                //loop until index  reaches 29
                for index in 0...29
                {
                    ImageCollection[index].isUserInteractionEnabled = false
                    ImageCollection[counter].image = shuffledArray[counter]
                    ImageCollection[index].isHidden = false
                    sec = 6
                    counter += 1
                }
            }
            //call timer.
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerCounter), userInfo: nil, repeats: true)
            
        }
    }
    
    // timer is used to count down to 5 seconds and also use timer to keep track of game timer
    @objc func timerCounter() {
        //count down to 5 timer
        if buttonCheck == true
        {
            //hide start and stop button
            startAndStopButton.isHidden = true
            //make sure label is not hidden
            LabelSec.isHidden = false
            //update labelSec label
            LabelSec.text = String(sec)
            //take one away from sec
            sec -= 1
            //update labelSec
            LabelSec.text = String(sec)
            //check is sec reaches 0
            if (sec == 0 || startAndStopButton.titleLabel?.text == "Stop" )
            {
                //set button check to false
                buttonCheck = false
                //startandStop is not hidden
                startAndStopButton.isHidden = false
                //label sec is hidden
                LabelSec.isHidden = true
                //startAndStopButton is set to stop
                startAndStopButton.titleLabel?.text = "Stop"
                //loop through imageViewCollection and turn on user intercation and cleat images from imageViews
                for imageView in ImageCollection
                {
                    imageView.isUserInteractionEnabled = true
                    imageView.image = nil
                }
                
            }
            
        }
        else
        {
            //add one to sec
            sec += 1
        }
        
    }
    @IBAction func UnwindToSecondView(segue:UIStoryboardSegue)
    {
        if segue.source is StatusViewController
        {
            //Start game when user touch button in first view.
            startAndStopButton.sendActions(for: .touchUpInside)
        }
    }
    
    //MARK:winner (check winner status)
    func CheckWinningStatus()
    {
        // add one to winCounter
        self.winCounter += 1
        //used to get mins and secs
        let minutes = sec / 60
        let seconds = sec % 60
        //add date formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MM/dd/yyyy"
        let date = NSDate()
        //convert to string
        dateString = dateFormate.string(from: date as Date)
        
        //check the current deviecs
        switch UIDevice.current.userInterfaceIdiom
        {
        case .phone:
            //check if user have 10 matches for iphone
            if self.winCounter == 10
            {
                winnerInfo.isHidden = false
                self.cardContainer.isHidden = true
                self.winnerInfo.text = "\n\n\nCONGRATS\n\nTime\n\n00:\(minutes):\(seconds)\n\nMOVES\n\n\(movesCount)\n\n\(dateString)"
                startAndStopButton.titleLabel?.text = "Start"
                //stop timer
                timer.invalidate()
                //shuffle Array
                shuffledArray =  shuffledArray.shuffled()
                buttonCheck = true
                winCounter = 0
                //call uialeart function
                nameUIAleart()
            }
        case .pad:
            if self.winCounter == 15
            {
                winnerInfo.isHidden = false
                self.cardContainer.isHidden = true
                self.winnerInfo.text = "\n\n\nCONGRATS\n\nTime\n\n00:\(minutes):\(seconds)\n\nMOVES\n\n\(movesCount)\n\n\(dateString)"
                startAndStopButton.titleLabel?.text = "Start"
                timer.invalidate()
                shuffledArray =  shuffledArray.shuffled()
                buttonCheck = true
                winCounter = 0
               //call uialeart function
              nameUIAleart()
            }
        default:
            break
        }
    }
    
    func nameUIAleart()
    {
        
        //Create the alert controller.
        let alert = UIAlertController(title: "Player name", message: "enter a username or initials", preferredStyle: .alert)
        
        //Add the text field
        alert.addTextField { (textField) in
            textField.placeholder = "userName"
        }
        
        // Grab the value from the text field,
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.userName = String(textField!.text!)
           // saveUserData method
            self.saveUserData()
        }))
        
        //call the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveUserData() {

        // identify the persistentContainer context using 'userScours' as the Entity class
        let userScore = UserScores(context: context)
        // assign it a value
        userScore.userName = userName
        userScore.date = dateString
        userScore.numberOfTurns = Int16(movesCount)
        userScore.timeCompletion = Int16(sec)

        do {
                try context.save()
                print("Saving data worked")
            }
            catch
            {
                print("Saving data Failed", error.localizedDescription)
            }
    }
    
}

