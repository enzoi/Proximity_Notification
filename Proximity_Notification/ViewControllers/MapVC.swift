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
    
    var longPressGesture: UILongPressGestureRecognizer? = nil
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set initial location in SF Botanical Garden
        let initialLocation = CLLocation(latitude: 37.7669, longitude: -122.4716)
        
        centerMapOnLocation(location: initialLocation)
        
        // Set up gestures and add
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        addLongPressGesture()
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Fetch all saved pins with annotation
    
    func fetchAllPins() {
        
        mapView.delegate = self
        
        // TODO: Get pins from Firebase
        
    }
    
    // MARK: Save Pin when created by gesture
    
    func savePin(latitude: Double, longitude: Double) {
        
        mapView.delegate = self
        
        // TODO: Save pin to Firebase
        
    }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        self.mapView.delegate = self
        
        if gestureRecognizer.state == .began {
            
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let lat = newCoordinates.latitude
            let lon = newCoordinates.longitude
            
            let pin = MKPointAnnotation()
            pin.coordinate = newCoordinates
            
            self.mapView.addAnnotation(pin)
            
            print("latitude: \(lat), longitude: \(lon)")
            // savePin(latitude: lat, longitude: lon)
            
        }
    }
    
    func addLongPressGesture() {
        self.longPressGesture?.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(self.longPressGesture!)
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
