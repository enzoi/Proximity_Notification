//
//  Plant.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/2/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import MapKit

struct Plant {
    
    let scientificName: String
    let commonName: String
    let photos: Photo
    let coordinate: CLLocationCoordinate2D
    let pin: MKAnnotation?

}

extension Plant {
    
    init(title: String, plantName: String, coordinate: CLLocationCoordinate2D) {
        self.plantName = plantName
        self.coordinate = coordinate
        self.pin = nil
    }
    
    var subtitle: String? {
        return plantName
    }
}
