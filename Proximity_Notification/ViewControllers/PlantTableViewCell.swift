//
//  PlantTableViewCell.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/25/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {


    @IBOutlet weak var plantImagemageView: UIImageView!
    @IBOutlet fileprivate weak var plantLabel: UILabel!
    @IBOutlet weak var commonName: UILabel!
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            plantLabel.text = model.scientificName
        }
    }
}

extension PlantTableViewCell {
    struct Model {
        let scientificName: String
        let commonName: String
        
        init(plant: Plant, index: Int) {
            self.scientificName = plant.scientificName
            self.commonName = plant.commonName

        }
    }
}

