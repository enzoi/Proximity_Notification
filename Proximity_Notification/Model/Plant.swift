//
//  Plant.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/2/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import Foundation
import MapKit

class Plant: NSObject, MKAnnotation {
    let title: String?
    let plantName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, plantName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.plantName = plantName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return plantName
    }
}
