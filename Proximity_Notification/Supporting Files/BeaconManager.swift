//
//  BeaconManager.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 11/1/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import UserNotifications

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = BeaconManager()
    
    var beaconRegions:[CLBeaconRegion] = []
    var beacons:[NSDictionary] = []
    var locationManager:CLLocationManager!
    
    func initializeBeacons(){
        let path = Bundle.main.path(forResource: "Beacons", ofType: "plist")
        guard let dictionary = NSDictionary(contentsOfFile: path!) else {return}
        
        if let beaconArray = dictionary["Beacons"] as? [NSDictionary] {
            self.beacons = beaconArray
            for dictionary in self.beacons {
                let uuid = dictionary["uuid"] as! String
                let major = dictionary["major"] as! String
                let minor = dictionary["minor"] as! String
                
                let beaconRegion = self.createBeaconRegionFor(uuidString: uuid, majorString: major, minorString: minor)
                
                self.beaconRegions.append(beaconRegion)
            }
            
            for beaconRegion in self.beaconRegions {
                self.locationManager.startMonitoring(for: beaconRegion)
            }
            
            self.locationManager.startUpdatingLocation()
        } else {return}
    }
    
    func setupForDiscovery(){
        self.initializeLocationManager {
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                self.initializeBeacons()
            } else {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
    }
    
    func initializeLocationManager(completion: @escaping () -> Void) {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        completion()
    }
    
    func stopBeaconDiscovery() {
        if self.beaconRegions.count > 0 {
            for beaconRegion in self.beaconRegions {
                self.locationManager.stopMonitoring(for: beaconRegion)
                self.locationManager.stopRangingBeacons(in: beaconRegion)
            }
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: Beacon handling
    func handleBeaconRanging(rangedBeacons:[CLBeacon], beaconRegion:CLBeaconRegion){
        
        for ranged in rangedBeacons {
            let rangedUUID = ranged.proximityUUID.uuidString
            let rangedProximity = ranged.proximity
            
            var storedProximity:CLProximity!
            var storedBeacon:NSDictionary!
            
            for beacon in self.beacons {
                guard let beaconUUID = beacon["uuid"] as? String else {return}
                
                if rangedUUID == beaconUUID {
                    storedBeacon = beacon
                }
            }
            
            storedProximity = self.getProximityFromString(proximityString: storedBeacon["proximity"] as! String)
            
            if rangedProximity == storedProximity {
                //We have a beacon that we're expecting. Let's further handle it.
                if !hasNotificationBeenScheduledForUUID(uuidString: rangedUUID){
                    self.scheduleNotificationForBeacon(beacon: storedBeacon)
                }
                
            }
            
            self.locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func notificationHasBeenScheduledForUUID(uuidString:String){
        if var dict = UserDefaults.standard.dictionary(forKey: "scheduledNotifications"){
            dict[uuidString] = Date()
            UserDefaults.standard.set(dict, forKey: "scheduledNotifications")
            UserDefaults.standard.synchronize()
        } else {
            let dict = [uuidString:Date()]
            UserDefaults.standard.set(dict, forKey: "scheduledNotifications")
            UserDefaults.standard.synchronize()
        }
    }
    
    func hasNotificationBeenScheduledForUUID(uuidString:String) -> Bool {
        var beenScheduled = false
        
        if let dict = UserDefaults.standard.dictionary(forKey: "scheduledNotifications"){
            if let _ = dict[uuidString]{
                beenScheduled = true
            }
        }
        
        return beenScheduled
    }
    
    func scheduleNotificationForBeacon(beacon:NSDictionary){
        let content = UNMutableNotificationContent()
        content.title = "CampusGuide"
        content.body = beacon["notificationMessage"] as! String
        content.sound = UNNotificationSound.default()
        content.badge = 1
        content.userInfo = beacon as! [AnyHashable:Any]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: "com.agi.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("successfully scheduled")
                self.notificationHasBeenScheduledForUUID(uuidString: beacon["uuid"] as! String)
            }
        }
    }
    
    // MARK: Helper
    func createBeaconRegionFor(uuidString:String, majorString:String, minorString:String) -> CLBeaconRegion {
        
        let unique = uuidString.substring(from: uuidString.index(uuidString.endIndex, offsetBy: -4))
        
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuidString)!, major: CLBeaconMajorValue(majorString)!, minor: CLBeaconMinorValue(minorString)!, identifier: "com.agi.beacon.\(unique)")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
    }
    
    func getAuthorizationStatus(status:CLAuthorizationStatus) -> String {
        switch status {
        case .authorizedAlways:
            return "Authorized Always"
        case .authorizedWhenInUse:
            return "Authorized When In Use"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        }
    }
    
    func getProximityFromString(proximityString:String) -> CLProximity{
        switch proximityString {
        case "Near":
            return CLProximity.near
        case "Immediate":
            return CLProximity.immediate
        case "Far":
            return CLProximity.far
        case "Unknown":
            return CLProximity.unknown
        default:
            return CLProximity.unknown
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
        
        if status == .authorizedAlways {
            self.initializeBeacons()
        } else {
            print("Unable to discover beacons: CLLocationManager status is: \(self.getAuthorizationStatus(status: status))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        //
        if state == .inside {
            locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
        } else {
            locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //
        print("Did enter region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //
        print("Did exit region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //
        if beacons.count > 0{
            self.handleBeaconRanging(rangedBeacons: beacons, beaconRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
        print("Failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        //
        print("Failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        //
        print("Failed: \(error)")
    }
    
}
