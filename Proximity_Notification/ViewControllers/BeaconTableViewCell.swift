//
//  BeaconTableViewCell.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/25/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    @IBOutlet weak var beaconNameLabel: UILabel!
    @IBOutlet weak var beaconLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
