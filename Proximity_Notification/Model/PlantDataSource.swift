//
//  PlantDataSource.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/7/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class PlantDataSource: NSObject {
    var plants: [Plant]
    
    init(plants: [Plant]) {
        self.plants = plants
    }
}

extension PlantDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantTableViewCell
        let index = indexPath.row
        let plant = plants[index]
        cell.model = PlantTableViewCell.Model(plant: plant, index: index)
        return cell
    }
}
