//
//  Plant.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/2/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import MapKit
import CoreLocation

enum LeafCategory: String {
    case evergreen
    case deciduous
}

enum PlantTypeCategory: String {
    case tree
    case shrub
    case groundcover
}

class Plant: NSObject, MKAnnotation {
    
    let title: String?
    let scientificName: String
    let commonName: String
    let plantType: PlantTypeCategory
    let leafType: LeafCategory
    let coordinate: CLLocationCoordinate2D
    let pin: MKAnnotation?
    
    init(scientificName: String, commonName: String, plantType: PlantTypeCategory, leafType: LeafCategory, coordinate: CLLocationCoordinate2D) {
        
        self.title = scientificName
        self.scientificName = scientificName
        self.commonName = commonName
        self.plantType = plantType
        self.leafType = leafType
        self.coordinate = coordinate
        self.pin = nil
        
        super.init()
    }
    
    var subtitle: String? {
        return commonName
    }
}
