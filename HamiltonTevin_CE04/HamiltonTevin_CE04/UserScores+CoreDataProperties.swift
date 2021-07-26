//
//  UserScores+CoreDataProperties.swift
//  HamiltonTevin_CE04
//
//  Created by Tevin Hamilton on 10/24/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//
//

import Foundation
import CoreData


extension UserScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserScores> {
        return NSFetchRequest<UserScores>(entityName: "UserScores")
    }

    @NSManaged public var date: String?
    @NSManaged public var userName: String?
    @NSManaged public var timeCompletion: Int16
    @NSManaged public var numberOfTurns: Int16

}
