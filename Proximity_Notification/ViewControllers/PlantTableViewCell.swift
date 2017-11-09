//
//  PlantTableViewCell.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/25/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var plantLabel: UILabel!
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            plantLabel.text = model.name
        }
    }
}

extension PlantTableViewCell {
    struct Model {
        let name: String
        
        init(plant: Plant, index: Int) {
            name = plant.plantName

        }
    }
}

