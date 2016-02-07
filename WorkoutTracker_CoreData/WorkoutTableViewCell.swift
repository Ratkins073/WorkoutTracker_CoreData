//
//  WorkoutTableViewCell.swift
//  WorkoutTracker
//
//  Created by Ryan Atkins on 2/5/16.
//  Copyright © 2016 Ryan Atkins. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
