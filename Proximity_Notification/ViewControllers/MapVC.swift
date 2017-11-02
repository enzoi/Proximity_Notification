//
//  MapVC.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/1/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set initial location in SF Botanical Garden
        let initialLocation = CLLocation(latitude: 37.7669, longitude: -122.4716)
        
        centerMapOnLocation(location: initialLocation)
        
        // Show plant on map
        let plant = Plant(title: "Plant #1",
                          plantName: "Pine Tree",
                          coordinate: CLLocationCoordinate2D(latitude: 37.7669, longitude: -122.4716))
        mapView.addAnnotation(plant)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Plant else { return nil }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
