//
//  AccountModel.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import Foundation
import CoreData

class AccountModel: NSManagedObject{
    @NSManaged var account_balance: Int
    @NSManaged var account_id: Int
    @NSManaged var date_created: Int
}
