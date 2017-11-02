//
//  RegionManager.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/26/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import Foundation
import CoreLocation

protocol RegionMonitorDelegate: NSObjectProtocol {
    func onBackgroundLocationAccessDisabled()
    func didStartMonitoring()
    func didStopMonitoring()
    func didEnterRegion(region: CLRegion!)
    func didExitRegion(region: CLRegion!)
    func didRangeBeacon(beacon: CLBeacon!, region: CLRegion!)
    func onError(error: NSError)
}

class RegionMonitor: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion?
    var rangedBeacon: CLBeacon! = CLBeacon()
    var pendingMonitorRequest: Bool = false
    
    weak var delegate: RegionMonitorDelegate?
    
    init(delegate: RegionMonitorDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
    }
    
    func startMonitoring(beaconRegion: CLBeaconRegion?) {
        print("Start monitoring")
        pendingMonitorRequest = true
        self.beaconRegion = beaconRegion
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied, .authorizedWhenInUse:
            delegate?.onBackgroundLocationAccessDisabled()
        case .authorizedAlways:
            locationManager!.startMonitoring(for: beaconRegion!)
            pendingMonitorRequest = false
        }
    }
    
    func stopMonitoring() {
        print("Stop monitoring")
        pendingMonitorRequest = false
        locationManager.stopRangingBeacons(in: beaconRegion!)
        locationManager.stopMonitoring(for: beaconRegion!)
        locationManager.stopUpdatingLocation()
        beaconRegion = nil
        delegate?.didStopMonitoring()
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus \(status)")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if pendingMonitorRequest {
                locationManager!.startMonitoring(for: beaconRegion!)
                pendingMonitorRequest = false
            }
            locationManager!.startUpdatingLocation()
        }
    }
    
    private func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("didStartMonitoringForRegion \(region.identifier)")
        delegate?.didStartMonitoring()
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("didDetermineState")
        if state == CLRegionState.inside {
            print(" - entered region \(region.identifier)")
            locationManager.startRangingBeacons(in: beaconRegion!)
        } else {
            print(" - exited region \(region.identifier)")
            locationManager.stopRangingBeacons(in: beaconRegion!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion - \(region.identifier)")
        delegate?.didEnterRegion(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion - \(region.identifier)")
        delegate?.didExitRegion(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("didRangeBeacons - \(region.identifier)")
        
        if beacons.count > 0 {
            rangedBeacon = beacons[0]
            delegate?.didRangeBeacon(beacon: rangedBeacon, region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoringDidFailForRegion - \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("rangingBeaconsDidFailForRegion \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error.localizedDescription == String(CLError.denied.rawValue)) {
            stopMonitoring()
        }
    }
    
    
}
