//
//  UserModel.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import Foundation
import CoreData

class UserModel: NSManagedObject{
    @NSManaged var card_no: String
    @NSManaged var card_pin: String
    @NSManaged var username: String
    @NSManaged var password: String
}
