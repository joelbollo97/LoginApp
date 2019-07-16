//
//  Cell.swift
//  Bank
//
//  Created by Joel Bollo on 15/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var accountDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
