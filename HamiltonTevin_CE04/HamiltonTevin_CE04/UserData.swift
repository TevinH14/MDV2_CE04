//
//  UserData.swift
//  HamiltonTevin_CE04
//
//  Created by Tevin Hamilton on 10/23/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//

import Foundation

class UserData
{
    //Stored props
    var userName:String
    var moveCount:Int
    var dateStamp:String
    var timeCompletion:Int
    
    //init
    init(userName:String, dataStamp:String, moveCount:Int, timeCompletion:Int)
    {
        self.userName = userName
        self.moveCount = moveCount
        self.dateStamp = dataStamp
        self.timeCompletion = timeCompletion
    }
}
